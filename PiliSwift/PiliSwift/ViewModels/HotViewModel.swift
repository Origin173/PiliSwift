import Foundation
import Observation

/// 热门视频 ViewModel
/// 对应 Flutter: lib/pages/hot/controller.dart
@Observable
final class HotViewModel {
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle
    private var pn = 1
    private let ps = 20

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch(refresh: true)
    }

    func refresh() async {
        pn = 1
        loadingState = .loading
        await fetch(refresh: true)
    }

    private func fetch(refresh: Bool) async {
        let result = await LoadingState.run {
            let params = ["pn": "\(pn)", "ps": "\(ps)"]
            let resp: APIResponse<HotData> = try await APIClient.shared.get(
                APIEndpoints.popularFeed, params: params
            )
            return resp.data?.list ?? []
        }
        loadingState = result
    }
}

struct HotData: Codable {
    let list: [RecVideoItem]?
    let noMore: Bool?
    enum CodingKeys: String, CodingKey {
        case list
        case noMore = "no_more"
    }
}
