import Foundation
import Observation

// MARK: - LiveViewModel
@Observable
final class LiveViewModel {
    private(set) var loadingState: LoadingState<[LiveRoomItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func refresh() async {
        loadingState = .loading
        await fetch()
    }

    private func fetch() async {
        let result = await LoadingState<[LiveRoomItem]>.run {
            let resp: APIResponse<LiveFeedData> = try await APIClient.shared.get(
                APIEndpoints.liveGetList, params: [
                    "platform": "web",
                    "parent_area_id": "0",
                    "area_id": "0",
                    "sort_type": ""
                ]
            )
            return resp.data?.list?.flatMap { $0.list } ?? []
        }
        loadingState = result
    }
}

struct LiveFeedData: Codable {
    let list: [LiveAreaGroup]?
}

struct LiveAreaGroup: Codable {
    let areaId: Int?
    let areaName: String?
    let list: [LiveRoomItem]
    enum CodingKeys: String, CodingKey {
        case list
        case areaId   = "area_id"
        case areaName = "area_name"
    }
}

// MARK: - LiveRoomViewModel
@Observable
final class LiveRoomViewModel {
    let roomId: Int64
    private(set) var loadingState: LoadingState<LiveRoomDetail> = .idle
    private(set) var danmakus: [LiveDanmaku] = []

    init(roomId: Int64) { self.roomId = roomId }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<LiveRoomDetail>.run {
            let resp: APIResponse<LiveRoomDetailData> = try await APIClient.shared.get(
                APIEndpoints.liveRoomInfo, params: ["room_id": "\(self.roomId)"]
            )
            guard let detail = resp.data?.roomInfo else {
                throw APIError.serverError(resp.code, resp.message ?? "")
            }
            return detail
        }
        loadingState = result
    }
}

struct LiveRoomDetailData: Codable {
    let roomInfo: LiveRoomDetail?
    let anchorInfo: AnchorInfo?

    struct AnchorInfo: Codable {
        let baseInfo: BaseInfo?
        struct BaseInfo: Codable {
            let uname: String?
            let face: String?
        }
        enum CodingKeys: String, CodingKey {
            case baseInfo = "base_info"
        }
    }

    enum CodingKeys: String, CodingKey {
        case roomInfo   = "room_info"
        case anchorInfo = "anchor_info"
    }
}

// MARK: - RankViewModel
@Observable
final class RankViewModel {
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[RecVideoItem]>.run {
            let params = ["rid": "0", "type": "all", "day": "3"]
            let resp: APIResponse<RankData> = try await APIClient.shared.get(
                APIEndpoints.popularRank, params: params
            )
            return resp.data?.list ?? []
        }
        loadingState = result
    }
}

struct RankData: Codable {
    let list: [RecVideoItem]?
    let note: String?
}
