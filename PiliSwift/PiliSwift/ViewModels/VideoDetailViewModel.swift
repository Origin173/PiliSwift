import Foundation
import AVKit
import Observation

/// 视频详情页 ViewModel
/// 对应 Flutter: lib/pages/video/controller.dart
@Observable
final class VideoDetailViewModel {
    let params: VideoDetailParams

    private(set) var loadingState: LoadingState<VideoDetail> = .idle
    private(set) var relatedVideos: [RecVideoItem] = []
    private(set) var player: AVPlayer? = nil
    private(set) var likeCount: String = "点赞"
    private(set) var favCount: String = "收藏"
    private(set) var hasLiked = false
    private(set) var hasCoined = false
    private(set) var hasFaved = false
    var danmakuOn = true
    var descExpanded = false

    init(params: VideoDetailParams) {
        self.params = params
    }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetchDetail()
    }

    private func fetchDetail() async {
        let result = await LoadingState<VideoDetail>.run {
            var queryParams: [String: String] = [:]
            if let bvid = params.bvid { queryParams["bvid"] = bvid }
            if let aid = params.aid   { queryParams["aid"] = "\(aid)" }
            let resp: APIResponse<VideoDetail> = try await APIClient.shared.getWbi(
                APIEndpoints.videoInfo, params: queryParams
            )
            guard let detail = resp.data else {
                throw APIError.serverError(resp.code, resp.message ?? "无数据")
            }
            return detail
        }
        loadingState = result

        if case .success(let detail) = result {
            // 同步加载播放地址和相关视频
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchPlayUrl(detail: detail) }
                group.addTask { await self.fetchRelated(bvid: detail.bvid) }
                group.addTask { await self.fetchLikeStatus(bvid: detail.bvid) }
                group.addTask { await self.fetchFavStatus(aid: detail.aid) }
            }
            if let stat = detail.stat {
                likeCount = stat.like.shortFormatted
                favCount  = stat.favorite.shortFormatted
            }
        }
    }

    private func fetchPlayUrl(detail: VideoDetail) async {
        guard let cid = detail.cid ?? params.cid else { return }
        do {
            var p: [String: String] = [
                "cid": "\(cid)",
                "qn": "\(Preferences.shared.defaultVideoQuality)",
                "fnval": "4048",
                "fourk": "1",
            ]
            if let bvid = detail.bvid as String? { p["bvid"] = bvid }
            let resp: APIResponse<VideoPlayInfo> = try await APIClient.shared.getWbi(
                APIEndpoints.videoPlayUrl, params: p
            )
            if let dashVideo = resp.data?.dash?.video?.first,
               let url = URL(string: dashVideo.baseUrl) {
                let item = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: item)
            }
        } catch {}
    }

    private func fetchRelated(bvid: String) async {
        do {
            let resp: APIResponse<RelatedData> = try await APIClient.shared.get(
                APIEndpoints.videoRelated, params: ["bvid": bvid]
            )
            relatedVideos = resp.data?.data ?? []
        } catch {}
    }

    private func fetchLikeStatus(bvid: String) async {
        do {
            let resp: APIResponse<LikeStatusData> = try await APIClient.shared.getWbi(
                APIEndpoints.videoLikeStatus, params: ["bvid": bvid]
            )
            hasLiked = resp.data?.liked == 1
        } catch {}
    }

    private func fetchFavStatus(aid: Int64) async {
        do {
            let resp: APIResponse<FavStatusData> = try await APIClient.shared.get(
                APIEndpoints.videoFavStatus, params: ["aid": "\(aid)"]
            )
            hasFaved = resp.data?.favoured == true
        } catch {}
    }

    // MARK: - 操作
    func toggleLike() async {
        guard case .success(let detail) = loadingState else { return }
        do {
            let like = hasLiked ? 2 : 1
            let resp: APIResponse<EmptyData> = try await APIClient.shared.post(
                APIEndpoints.videoLike,
                params: ["bvid": detail.bvid, "like": "\(like)"]
            )
            if resp.code == 0 { hasLiked.toggle() }
        } catch {}
    }

    func coin() async {}

    func toggleFav() async {}

    func share() {
        guard case .success(let detail) = loadingState else { return }
        let text = "https://www.bilibili.com/video/\(detail.bvid)"
        UIPasteboard.general.string = text
    }

    func toggleFollow(mid: Int64) async {}
}

// MARK: - 辅助模型
struct RelatedData: Codable { let data: [RecVideoItem]? }
struct LikeStatusData: Codable { let liked: Int? }
struct FavStatusData: Codable { let favoured: Bool? }
struct EmptyData: Codable {}
