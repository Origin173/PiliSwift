import Foundation
import Observation

/// 首页推荐视频流 ViewModel
/// 对应 Flutter: lib/pages/home/controller.dart
@Observable
final class HomeViewModel {
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle
    private var refreshIdx: Int = 0

    func loadInitial() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetchRecommend(refresh: true)
    }

    func refresh() async {
        refreshIdx = 0
        loadingState = .loading
        await fetchRecommend(refresh: true)
    }

    func loadMore() async {
        guard case .success(let items) = loadingState else { return }
        let newItems = await fetchPage()
        loadingState = .success(items + newItems)
    }

    private func fetchRecommend(refresh: Bool) async {
        let result = await LoadingState<[RecVideoItem]>.run {
            let params: [String: String] = [
                "fresh_type": "3",
                "version": "1",
                "ps": "12",
                "feed_version": "V8",
                "fresh_idx": "\(self.refreshIdx)",
                "fresh_idx_1h": "\(self.refreshIdx)",
            ]
            let resp: APIResponse<RecommendData> = try await APIClient.shared.getWbi(
                APIEndpoints.recommend,
                params: params
            )
            return resp.data?.items ?? []
        }
        loadingState = result
    }

    private func fetchPage() async -> [RecVideoItem] {
        refreshIdx += 1
        do {
            let params: [String: String] = [
                "fresh_type": "3",
                "version": "1",
                "ps": "12",
                "feed_version": "V8",
                "fresh_idx": "\(refreshIdx)",
                "fresh_idx_1h": "\(refreshIdx)",
            ]
            let resp: APIResponse<RecommendData> = try await APIClient.shared.getWbi(
                APIEndpoints.recommend,
                params: params
            )
            return resp.data?.items ?? []
        } catch {
            return []
        }
    }
}

// MARK: - 推荐响应模型
struct RecommendData: Codable {
    let items: [RecVideoItem]?
}
