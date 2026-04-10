import Foundation
import Observation

// MARK: - SearchViewModel（搜索建议）
@Observable
final class SearchViewModel {
    private(set) var suggestions: [String] = []

    func fetchSuggestions(keyword: String) async {
        guard !keyword.isEmpty else {
            suggestions = []
            return
        }
        do {
            let params = ["term": keyword, "main_ver": "v1", "highlight": ""]
            let resp: APIResponse<SuggestData> = try await APIClient.shared.get(
                APIEndpoints.searchSuggest, params: params
            )
            suggestions = resp.data?.result?.compactMap { $0.value } ?? []
        } catch {
            suggestions = []
        }
    }
}

struct SuggestData: Codable {
    let result: [SuggestItem]?
}
struct SuggestItem: Codable {
    let term: String?
    let value: String?
    let ref: Int?
}

// MARK: - SearchTrendingViewModel（热搜）
@Observable
final class SearchTrendingViewModel {
    private(set) var loadingState: LoadingState<[String]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[String]>.run {
            let resp: APIResponse<TrendingData> = try await APIClient.shared.get(
                APIEndpoints.searchHot, params: ["limit": "50", "platform": "web"]
            )
            return resp.data?.trending?.list?.map { $0.keyword ?? "" }.filter { !$0.isEmpty } ?? []
        }
        loadingState = result
    }
}

struct TrendingData: Codable {
    let trending: TrendingList?
    struct TrendingList: Codable {
        let list: [TrendingItem]?
    }
}
struct TrendingItem: Codable {
    let keyword: String?
    let showName: String?
    let icon: String?
    let hotId: Int?
    let heatScore: Int?
    enum CodingKeys: String, CodingKey {
        case keyword, icon
        case showName  = "show_name"
        case hotId     = "hot_id"
        case heatScore = "heat_score"
    }
}

// MARK: - SearchResultViewModel（搜索结果）
@Observable
final class SearchResultViewModel {
    let keyword: String
    private(set) var loadingState: LoadingState<[SearchResultItem]> = .idle
    private var page = 1
    private let pageSize = 20
    private var hasMore = true

    init(keyword: String) { self.keyword = keyword }

    func search() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch(reset: true)
    }

    func loadMore() async {
        guard hasMore, case .success(let items) = loadingState else { return }
        page += 1
        let result = await LoadingState<[SearchResultItem]>.run {
            let params: [String: String] = [
                "keyword": self.keyword,
                "search_type": "video",
                "page": "\(self.page)",
                "page_size": "\(self.pageSize)",
            ]
            let resp: APIResponse<SearchResultData> = try await APIClient.shared.getWbi(
                APIEndpoints.searchAll, params: params
            )
            let newItems = resp.data?.result ?? []
            self.hasMore = newItems.count == self.pageSize
            return items + newItems
        }
        if case .success(let all) = result {
            loadingState = .success(all)
        }
    }

    private func fetch(reset: Bool) async {
        if reset { page = 1 }
        let result = await LoadingState<[SearchResultItem]>.run {
            let params: [String: String] = [
                "keyword": self.keyword,
                "search_type": "video",
                "page": "\(self.page)",
                "page_size": "\(self.pageSize)",
            ]
            let resp: APIResponse<SearchResultData> = try await APIClient.shared.getWbi(
                APIEndpoints.searchAll, params: params
            )
            let items = resp.data?.result ?? []
            self.hasMore = items.count == self.pageSize
            return items
        }
        loadingState = result
    }
}

struct SearchResultData: Codable {
    let result: [SearchResultItem]?
    let pagesize: Int?
    let numResults: Int?
}
