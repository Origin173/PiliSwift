import Foundation
import Observation

// MARK: - DynamicDetailViewModel
@Observable
final class DynamicDetailViewModel {
    let id: String
    private(set) var loadingState: LoadingState<DynamicItem> = .idle

    init(id: String) { self.id = id }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<DynamicItem>.run {
            let resp: APIResponse<DynamicDetailData> = try await APIClient.shared.get(
                APIEndpoints.dynamicDetail, params: ["id": self.id]
            )
            guard let item = resp.data?.item else {
                throw APIError.serverError(resp.code, resp.message ?? "")
            }
            return item
        }
        loadingState = result
    }
}

struct DynamicDetailData: Codable {
    let item: DynamicItem?
}

// MARK: - FavViewModel（收藏夹列表）
@Observable
final class FavViewModel {
    let mid: Int64
    private(set) var loadingState: LoadingState<[FavFolder]> = .idle

    init(mid: Int64) { self.mid = mid }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[FavFolder]>.run {
            let resp: APIResponse<FavListData> = try await APIClient.shared.get(
                APIEndpoints.favFolderList, params: ["up_mid": "\(self.mid)", "type": "2"]
            )
            return resp.data?.list ?? []
        }
        loadingState = result
    }
}

struct FavListData: Codable {
    let list: [FavFolder]?
    let count: Int?
}

// MARK: - FavDetailViewModel（收藏夹内容）
@Observable
final class FavDetailViewModel {
    let mediaId: Int64
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle
    private var pn = 1
    private let ps = 20
    private var hasMore = true

    init(mediaId: Int64) { self.mediaId = mediaId }

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
            let params = ["media_id": "\(mediaId)", "pn": "\(pn)", "ps": "\(ps)",
                          "order": "mtime", "type": "0", "platform": "web"]
            let resp: APIResponse<FavDetailData> = try await APIClient.shared.get(
                APIEndpoints.favDetail, params: params
            )
            let newItems = resp.data?.medias?.map { $0.asRecVideoItem } ?? []
            hasMore = resp.data?.hasMore ?? false
            loadingState = .success(items + newItems)
        } catch {}
    }

    private func fetch() async {
        let result = await LoadingState<[RecVideoItem]>.run {
            let params = ["media_id": "\(self.mediaId)", "pn": "1", "ps": "\(self.ps)",
                          "order": "mtime", "type": "0", "platform": "web"]
            let resp: APIResponse<FavDetailData> = try await APIClient.shared.get(
                APIEndpoints.favDetail, params: params
            )
            self.hasMore = resp.data?.hasMore ?? false
            return resp.data?.medias?.map { $0.asRecVideoItem } ?? []
        }
        loadingState = result
    }
}

struct FavDetailData: Codable {
    let info: FavFolder?
    let medias: [FavDetailResponse.FavMedia]?
    let hasMore: Bool?
    enum CodingKeys: String, CodingKey {
        case info, medias
        case hasMore = "has_more"
    }
}
