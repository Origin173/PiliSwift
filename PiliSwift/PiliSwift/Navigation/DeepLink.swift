import Foundation

// MARK: - Deep Link 解析器
// 映射自 ios/Runner/Info.plist 中注册的 URL Scheme
// 支持 bilibili:// 和 https://m.bilibili.com 等

enum DeepLink {
    /// 解析传入的 URL，返回对应的 Route（如无法识别返回 nil）
    static func parse(_ url: URL) -> Route? {
        // bilibili:// 自定义 Scheme
        if url.scheme == "bilibili" {
            return parseBilibiliScheme(url)
        }

        // HTTPS 链接
        if url.scheme == "https" || url.scheme == "http" {
            return parseWebURL(url)
        }

        return nil
    }

    // MARK: - bilibili:// scheme 解析

    private static func parseBilibiliScheme(_ url: URL) -> Route? {
        guard let host = url.host else { return nil }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        func param(_ name: String) -> String? {
            queryItems.first { $0.name == name }?.value
        }

        switch host.lowercased() {
        case "video":
            // bilibili://video/{bvid} 或 bilibili://video?aid=xxx
            let bvid = url.pathComponents.dropFirst().first
            let aid  = param("aid").flatMap { Int64($0) }
            let cid  = param("cid").flatMap { Int64($0) }
            return .videoDetail(VideoDetailParams(bvid: bvid, aid: aid, cid: cid))

        case "bangumi", "pgc":
            // bilibili://bangumi/season/{seasonId} 或 bilibili://bangumi/ep/{epId}
            let segments = url.pathComponents.dropFirst()
            if segments.first == "season", let id = segments.dropFirst().first.flatMap({ Int64($0) }) {
                return .pgc(id)
            } else if segments.first == "ep", let epId = segments.dropFirst().first.flatMap({ Int64($0) }) {
                return .videoDetail(VideoDetailParams(epId: epId))
            }
            return nil

        case "live":
            // bilibili://live/{roomId}
            if let roomId = url.pathComponents.dropFirst().first.flatMap({ Int64($0) }) {
                return .liveRoom(roomId)
            }
            return nil

        case "space":
            // bilibili://space/{mid}
            if let mid = url.pathComponents.dropFirst().first.flatMap({ Int64($0) }) {
                return .member(mid)
            }
            return nil

        case "dynamic", "opus":
            // bilibili://dynamic/{dynamicId}
            if let dynId = url.pathComponents.dropFirst().first {
                return .dynamicDetail(dynId)
            }
            return nil

        default:
            return nil
        }
    }

    // MARK: - Web URL 解析

    private static func parseWebURL(_ url: URL) -> Route? {
        guard let host = url.host else { return nil }

        let path = url.path
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        func param(_ name: String) -> String? {
            queryItems.first { $0.name == name }?.value
        }

        // m.bilibili.com / www.bilibili.com / bilibili.com
        let isMainSite = host.contains("bilibili.com") && !host.hasPrefix("live.")
            && !host.hasPrefix("bangumi.")

        // live.bilibili.com
        if host.hasPrefix("live.") {
            // live.bilibili.com/room/{roomId} 或 live.bilibili.com/{roomId}
            let segments = path.split(separator: "/").map(String.init)
            let idSeg = segments.first { Int64($0) != nil } ?? segments.last
            if let roomId = idSeg.flatMap({ Int64($0) }) {
                return .liveRoom(roomId)
            }
            return nil
        }

        // bangumi.bilibili.com/anime/...
        if host.hasPrefix("bangumi.") {
            if let seasonId = param("season_id").flatMap({ Int64($0) }) {
                return .pgc(seasonId)
            }
            if let epId = param("ep_id").flatMap({ Int64($0) }) {
                return .videoDetail(VideoDetailParams(epId: epId))
            }
            return nil
        }

        if isMainSite {
            // /video/BVxxx 或 /video/avXXX
            if path.hasPrefix("/video/") {
                let segment = path.dropFirst("/video/".count).components(separatedBy: "/").first ?? ""
                if segment.hasPrefix("BV") || segment.hasPrefix("bv") {
                    return .videoDetail(VideoDetailParams(bvid: segment))
                } else if segment.hasPrefix("av") || segment.hasPrefix("AV") {
                    let aid = Int64(segment.dropFirst(2))
                    return .videoDetail(VideoDetailParams(aid: aid))
                }
            }

            // /bangumi/play/ep{epId} 或 /bangumi/play/ss{seasonId}
            if path.hasPrefix("/bangumi/play/ep") {
                let epId = Int64(path.dropFirst("/bangumi/play/ep".count).components(separatedBy: "/").first ?? "")
                return .videoDetail(VideoDetailParams(epId: epId))
            }
            if path.hasPrefix("/bangumi/play/ss") {
                let seasonId = Int64(path.dropFirst("/bangumi/play/ss".count).components(separatedBy: "/").first ?? "")
                return seasonId.map { .pgc($0) }
            }

            // /space/{mid}
            if path.hasPrefix("/space/") || path.hasPrefix("/@") {
                let segment = path.hasPrefix("/space/")
                    ? path.dropFirst("/space/".count).components(separatedBy: "/").first ?? ""
                    : path.dropFirst("/@".count).components(separatedBy: "/").first ?? ""
                if let mid = Int64(segment) {
                    return .member(mid)
                }
            }

            // /t/{dynamicId} 或 /opus/{opusId}
            if path.hasPrefix("/t/") || path.hasPrefix("/opus/") {
                let segment = path.components(separatedBy: "/").last ?? ""
                if !segment.isEmpty {
                    return .dynamicDetail(segment)
                }
            }
        }

        // 兜底：用 webview 打开
        return .webview(url)
    }
}
