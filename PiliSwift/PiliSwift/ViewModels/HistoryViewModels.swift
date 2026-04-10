import Foundation
import Observation

// MARK: - HistoryViewModel
@Observable
final class HistoryViewModel {
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle
    private var cursor: HistoryCursor? = nil
    private var hasMore = true

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func refresh() async {
        cursor = nil
        hasMore = true
        loadingState = .loading
        await fetch()
    }

    func loadMore() async {
        guard hasMore, case .success(let items) = loadingState else { return }
        let newItems = await fetchPage()
        loadingState = .success(items + newItems)
    }

    func delete(item: RecVideoItem) async {}

    private func fetch() async {
        let result = await LoadingState<[RecVideoItem]>.run {
            await self.fetchPage()
        }
        loadingState = result
    }

    private func fetchPage() async -> [RecVideoItem] {
        do {
            var params: [String: String] = [
                "type": "archive",
                "ps": "30",
            ]
            if let cursor = cursor {
                params["max"] = "\(cursor.max)"
                params["view_at"] = "\(cursor.viewAt)"
                params["business"] = cursor.business
            }
            let resp: APIResponse<HistoryData> = try await APIClient.shared.get(
                APIEndpoints.historyList, params: params
            )
            cursor = resp.data?.cursor
            hasMore = resp.data?.hasMore ?? false
            return resp.data?.list?.map { $0.asRecVideoItem } ?? []
        } catch {
            return []
        }
    }
}

struct HistoryData: Codable {
    let cursor: HistoryCursor?
    let list: [HistoryItem]?
    let hasMore: Bool?
    enum CodingKeys: String, CodingKey { case cursor, list; case hasMore = "has_more" }
}
struct HistoryCursor: Codable {
    let max: Int64
    let viewAt: Int64
    let business: String
    enum CodingKeys: String, CodingKey { case max; case viewAt = "view_at"; case business }
}
struct HistoryItem: Codable {
    let oid: Int64?
    let bvid: String?
    let title: String?
    let cover: String?
    let uri: String?
    let authorMid: Int64?
    let authorName: String?
    let authorFace: String?
    let viewAt: Int64?
    let duration: Int?
    let badge: String?

    var asRecVideoItem: RecVideoItem {
        RecVideoItem(
            aid: oid ?? 0, bvid: bvid ?? "",
            title: title ?? "",
            pic: cover,
            desc: nil,
            owner: VideoOwner(mid: authorMid ?? 0, name: authorName ?? "", face: authorFace ?? ""),
            stat: VideoStat(view: 0, danmaku: 0, reply: 0, favorite: 0, coin: 0,
                            share: 0, nowRank: nil, hisRank: nil, like: 0, dislike: nil),
            duration: duration ?? 0,
            pubdate: viewAt,
            rcmdReason: nil, goto: "av", uri: uri, tid: nil, tname: nil
        )
    }

    enum CodingKeys: String, CodingKey {
        case oid, bvid, title, cover, uri, duration, badge
        case authorMid  = "main_author_mid"
        case authorName = "main_author_name"
        case authorFace = "main_author_face"
        case viewAt     = "view_at"
    }
}

// MARK: - LaterViewModel（稍后再看）
@Observable
final class LaterViewModel {
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func refresh() async {
        loadingState = .loading
        await fetch()
    }

    func delete(item: RecVideoItem) async {
        guard case .success(var items) = loadingState else { return }
        items.removeAll { $0.aid == item.aid }
        loadingState = .success(items)
        do {
            let _: APIResponse<EmptyData> = try await APIClient.shared.post(
                APIEndpoints.watchLaterDel, params: ["aid": "\(item.aid)"]
            )
        } catch {}
    }

    private func fetch() async {
        let result = await LoadingState<[RecVideoItem]>.run {
            let resp: APIResponse<LaterData> = try await APIClient.shared.get(
                APIEndpoints.watchLaterList, params: [:]
            )
            return resp.data?.list?.map { $0.asRecVideoItem } ?? []
        }
        loadingState = result
    }
}

struct LaterData: Codable {
    let count: Int?
    let list: [LaterItem]?
}
struct LaterItem: Codable {
    let aid: Int64
    let bvid: String
    let title: String
    let pic: String?
    let duration: Int?
    let owner: VideoOwner
    let stat: VideoStat?
    let cid: Int64?
    let pubdate: Int64?

    var asRecVideoItem: RecVideoItem {
        RecVideoItem(
            aid: aid, bvid: bvid, title: title, pic: pic, desc: nil,
            owner: owner,
            stat: stat ?? VideoStat(view: 0, danmaku: 0, reply: 0, favorite: 0, coin: 0,
                                    share: 0, nowRank: nil, hisRank: nil, like: 0, dislike: nil),
            duration: duration ?? 0, pubdate: pubdate, rcmdReason: nil,
            goto: "av", uri: nil, tid: nil, tname: nil
        )
    }
}
