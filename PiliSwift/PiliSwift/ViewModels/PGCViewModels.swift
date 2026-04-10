import Foundation
import Observation

// MARK: - PGCViewModel（番剧详情）
@Observable
final class PGCViewModel {
    let seasonId: Int64
    private(set) var loadingState: LoadingState<PGCSeason> = .idle

    init(seasonId: Int64) { self.seasonId = seasonId }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<PGCSeason>.run {
            let resp: APIResponse<PGCSeasonData> = try await APIClient.shared.get(
                APIEndpoints.pgcInfo,
                params: ["season_id": "\(self.seasonId)", "season_type": "1"]
            )
            guard let season = resp.data?.result else {
                throw APIError.serverError(resp.code, resp.message ?? "")
            }
            return season
        }
        loadingState = result
    }
}

struct PGCSeasonData: Codable {
    let result: PGCSeason?
}

// MARK: - SubscriptionViewModel（我的追番/追剧）
@Observable
final class SubscriptionViewModel {
    private(set) var loadingState: LoadingState<[SubscriptionSeason]> = .idle
    private var pn = 1
    private let ps = 30
    private var hasMore = true

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

    private func fetch() async {
        let result = await LoadingState<[SubscriptionSeason]>.run {
            let params = ["pn": "\(self.pn)", "ps": "\(self.ps)",
                          "follow_status": "0", "type": "1", "version": "0"]
            let resp: APIResponse<SubscriptionData> = try await APIClient.shared.get(
                APIEndpoints.pgcFollowList, params: params
            )
            self.hasMore = resp.data?.hasNext ?? false
            return resp.data?.followList ?? []
        }
        loadingState = result
    }
}

struct SubscriptionData: Codable {
    let followList: [SubscriptionSeason]?
    let hasNext: Bool?
    let total: Int?
    enum CodingKeys: String, CodingKey {
        case total
        case followList = "follow_list"
        case hasNext    = "has_next"
    }
}
