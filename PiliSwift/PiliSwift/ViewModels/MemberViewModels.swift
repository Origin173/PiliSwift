import Foundation
import Observation

// MARK: - MemberViewModel
@Observable
final class MemberViewModel {
    let mid: Int64
    private(set) var loadingState: LoadingState<MemberInfo> = .idle

    init(mid: Int64) { self.mid = mid }

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<MemberInfo>.run {
            let resp: APIResponse<MemberInfoData> = try await APIClient.shared.get(
                APIEndpoints.memberInfo, params: ["mid": "\(self.mid)"]
            )
            guard let card = resp.data?.card else {
                throw APIError.serverError(resp.code, resp.message ?? "")
            }
            return card
        }
        loadingState = result
    }
}

struct MemberInfoData: Codable {
    let card: MemberInfo?
    let follower: Int?
    let like_num: Int?
}

// MARK: - MemberVideoViewModel
@Observable
final class MemberVideoViewModel: UserListViewModel {
    let mid: Int64
    private(set) var loadingState: LoadingState<[RecVideoItem]> = .idle
    private var pn = 1
    private let ps = 30
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
            let params = ["mid": "\(mid)", "ps": "\(ps)", "pn": "\(pn)",
                          "order": "pubdate", "platform": "web"]
            let resp: APIResponse<MemberVideoData> = try await APIClient.shared.getWbi(
                APIEndpoints.memberVideo, params: params
            )
            let newItems = resp.data?.list?.vlist?.map { $0.asRecVideoItem } ?? []
            hasMore = newItems.count == ps
            loadingState = .success(items + newItems)
        } catch {}
    }

    private func fetch() async {
        let result = await LoadingState<[RecVideoItem]>.run {
            let params = ["mid": "\(self.mid)", "ps": "\(self.ps)", "pn": "1",
                          "order": "pubdate", "platform": "web"]
            let resp: APIResponse<MemberVideoData> = try await APIClient.shared.getWbi(
                APIEndpoints.memberVideo, params: params
            )
            return resp.data?.list?.vlist?.map { $0.asRecVideoItem } ?? []
        }
        loadingState = result
    }
}

// Member API 辅助模型
struct MemberVideoData: Codable {
    let list: MemberVideoList?
    let page: MemberVideoPage?
}
struct MemberVideoList: Codable {
    let vlist: [MemberVideoItem]?
}
struct MemberVideoItem: Codable {
    let aid: Int64
    let bvid: String
    let title: String
    let pic: String?
    let created: Int64?
    let length: String?
    let play: Int?
    let description: String?
    let mid: Int64?
    let author: String?

    var asRecVideoItem: RecVideoItem {
        RecVideoItem(
            aid: aid, bvid: bvid, title: title, pic: pic, desc: description,
            owner: VideoOwner(mid: mid ?? 0, name: author ?? "", face: ""),
            stat: VideoStat(view: play ?? 0, danmaku: 0, reply: 0, favorite: 0, coin: 0,
                            share: 0, nowRank: nil, hisRank: nil, like: 0, dislike: nil),
            duration: 0, pubdate: created, rcmdReason: nil, goto: "av", uri: nil,
            tid: nil, tname: nil
        )
    }
}
struct MemberVideoPage: Codable {
    let count: Int?
    let pn: Int?
    let ps: Int?
}
