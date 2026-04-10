import Foundation
import Observation

// MARK: - FollowViewModel（关注列表）
@Observable
final class FollowViewModel: UserListViewModel {
    let mid: Int64
    private(set) var loadingState: LoadingState<[FollowItem]> = .idle
    private var pn = 1
    private let ps = 50
    private var hasMore = true

    init(mid: Int64) { self.mid = mid }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func refresh() async {
        pn = 1
        hasMore = true
        loadingState = .loading
        await fetch()
    }

    func loadMore() async {
        guard hasMore, case .success(let items) = loadingState else { return }
        pn += 1
        do {
            let params = ["vmid": "\(mid)", "pn": "\(pn)", "ps": "\(ps)", "order": "desc"]
            let resp: APIResponse<FollowListData> = try await APIClient.shared.get(
                APIEndpoints.followings, params: params
            )
            let newItems = resp.data?.list ?? []
            hasMore = newItems.count == ps
            loadingState = .success(items + newItems)
        } catch {}
    }

    private func fetch() async {
        let result = await LoadingState<[FollowItem]>.run {
            let params = ["vmid": "\(self.mid)", "pn": "1", "ps": "\(self.ps)", "order": "desc"]
            let resp: APIResponse<FollowListData> = try await APIClient.shared.get(
                APIEndpoints.followings, params: params
            )
            self.hasMore = (resp.data?.list?.count ?? 0) == self.ps
            return resp.data?.list ?? []
        }
        loadingState = result
    }
}

struct FollowListData: Codable {
    let list: [FollowItem]?
    let total: Int?
}

// MARK: - FanViewModel（粉丝列表）
@Observable
final class FanViewModel: UserListViewModel {
    let mid: Int64
    private(set) var loadingState: LoadingState<[FollowItem]> = .idle
    private var pn = 1
    private let ps = 50
    private var hasMore = true

    init(mid: Int64) { self.mid = mid }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func loadMore() async {
        guard hasMore, case .success(let items) = loadingState else { return }
        pn += 1
        do {
            let params = ["vmid": "\(mid)", "pn": "\(pn)", "ps": "\(ps)"]
            let resp: APIResponse<FollowListData> = try await APIClient.shared.get(
                APIEndpoints.followers, params: params
            )
            let newItems = resp.data?.list ?? []
            hasMore = newItems.count == ps
            loadingState = .success(items + newItems)
        } catch {}
    }

    private func fetch() async {
        let result = await LoadingState<[FollowItem]>.run {
            let params = ["vmid": "\(self.mid)", "pn": "1", "ps": "\(self.ps)"]
            let resp: APIResponse<FollowListData> = try await APIClient.shared.get(
                APIEndpoints.followers, params: params
            )
            return resp.data?.list ?? []
        }
        loadingState = result
    }
}
