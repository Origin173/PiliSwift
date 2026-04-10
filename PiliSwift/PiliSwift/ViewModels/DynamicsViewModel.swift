import Foundation
import Observation

/// 动态列表 ViewModel
/// 对应 Flutter: lib/pages/dynamics/dynamic_controller.dart
@Observable
final class DynamicsViewModel {
    private(set) var loadingState: LoadingState<[DynamicItem]> = .idle
    private var offset: String = ""
    private var hasMore = true

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetchDynamics(offset: "")
    }

    func refresh() async {
        offset = ""
        hasMore = true
        loadingState = .loading
        await fetchDynamics(offset: "")
    }

    /// 用于 MemberDynamicsView — 加载指定 UP 主的动态
    func loadForMember(mid: Int64) async {
        guard case .idle = loadingState else { return }
        loadingState = .loading

        let result = await LoadingState<[DynamicItem]>.run {
            let params: [String: String] = [
                "host_mid": "\(mid)",
                "offset": self.offset,
                "timezone_offset": "-480",
                "features": "itemOpusStyle,opusBigCover,onlyfansVote,endFooter,decorationCard,ugcDelete",
            ]
            let resp: APIResponse<DynamicListData> = try await APIClient.shared.get(
                APIEndpoints.dynamicFeed, params: params
            )
            let items = resp.data?.items ?? []
            self.offset = resp.data?.offset ?? ""
            self.hasMore = resp.data?.hasMore ?? false
            return items
        }
        loadingState = result
    }

    func loadMore() async {
        guard hasMore, case .success(let items) = loadingState else { return }
        let result = await LoadingState<[DynamicItem]>.run {
            let params: [String: String] = [
                "offset": self.offset,
                "timezone_offset": "-480",
                "features": "itemOpusStyle,opusBigCover,onlyfansVote,endFooter,decorationCard,ugcDelete",
            ]
            let resp: APIResponse<DynamicListData> = try await APIClient.shared.get(
                APIEndpoints.dynamicFeed, params: params
            )
            let newItems = resp.data?.items ?? []
            self.offset = resp.data?.offset ?? ""
            self.hasMore = resp.data?.hasMore ?? false
            return items + newItems
        }
        if case .success(let all) = result {
            loadingState = .success(all)
        }
    }

    private func fetchDynamics(offset: String) async {
        let result = await LoadingState<[DynamicItem]>.run {
            let params: [String: String] = [
                "offset": self.offset,
                "timezone_offset": "-480",
                "features": "itemOpusStyle,opusBigCover,onlyfansVote,endFooter,decorationCard,ugcDelete",
            ]
            let resp: APIResponse<DynamicListData> = try await APIClient.shared.get(
                APIEndpoints.dynamicFeed, params: params
            )
            let items = resp.data?.items ?? []
            self.offset = resp.data?.offset ?? ""
            self.hasMore = resp.data?.hasMore ?? false
            return items
        }
        loadingState = result
    }
}

struct DynamicListData: Codable {
    let items: [DynamicItem]?
    let offset: String?
    let hasMore: Bool?
    enum CodingKeys: String, CodingKey {
        case items, offset
        case hasMore = "has_more"
    }
}
