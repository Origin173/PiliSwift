import Foundation
import Observation

// MARK: - WhisperViewModel（私信会话列表）
@Observable
final class WhisperViewModel {
    private(set) var loadingState: LoadingState<[WhisperSession]> = .idle
    private var seqack: Int64 = 0

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        await fetch()
    }

    func refresh() async {
        seqack = 0
        loadingState = .loading
        await fetch()
    }

    private func fetch() async {
        let result = await LoadingState<[WhisperSession]>.run {
            let resp: APIResponse<SessionListData> = try await APIClient.shared.get(
                APIEndpoints.msgSession,
                params: ["session_type": "1", "group_fold": "1", "unfollow_fold": "0",
                         "sort_rule": "2", "build": "0", "mobi_app": "web"]
            )
            return resp.data?.sessionList ?? []
        }
        loadingState = result
    }
}

struct SessionListData: Codable {
    let sessionList: [WhisperSession]?
    let hasMore: Bool?
    enum CodingKeys: String, CodingKey {
        case sessionList = "session_list"
        case hasMore     = "has_more"
    }
}

// MARK: - WhisperDetailViewModel（私信对话）
@Observable
final class WhisperDetailViewModel {
    let talkerId: Int64
    private(set) var messages: [WhisperMessage] = []
    var inputText: String = ""
    private var seqno: Int64 = 0

    init(talkerId: Int64) { self.talkerId = talkerId }

    func load() async {
        do {
            let resp: APIResponse<MsgListData> = try await APIClient.shared.get(
                APIEndpoints.msgFetchSession,
                params: ["session_type": "1", "talker_id": "\(talkerId)",
                         "size": "20", "sender_device_id": "1"]
            )
            let myUid = AccountStorage.shared.uid
            let msgs = (resp.data?.messages ?? []).map { msg -> WhisperMessage in
                var m = msg
                m.isMine = m.senderUid == myUid
                return m
            }
            messages = msgs.reversed()
            seqno = messages.last?.msgId ?? 0
        } catch {}
    }

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        inputText = ""
        do {
            let devTime = Int64(Date().timeIntervalSince1970 * 1000)
            let _: APIResponse<EmptyData> = try await APIClient.shared.post(
                APIEndpoints.msgSend,
                params: [
                    "msg[sender_uid]": "\(AccountStorage.shared.uid ?? 0)",
                    "msg[receiver_id]": "\(talkerId)",
                    "msg[receiver_type]": "1",
                    "msg[msg_type]": "1",
                    "msg[msg_status]": "0",
                    "msg[content]": "{\"content\":\"\(text)\"}",
                    "msg[timestamp]": "\(Int64(Date().timeIntervalSince1970))",
                    "msg[new_face_version]": "0",
                    "msg[dev_id]": "\(devTime)",
                    "from_firework": "0",
                ]
            )
        } catch {}
    }
}

struct MsgListData: Codable {
    let messages: [WhisperMessage]?
    let hasMore: Bool?
    enum CodingKeys: String, CodingKey {
        case messages = "messages"
        case hasMore  = "has_more"
    }
}

// MARK: - ReplyMeViewModel
@Observable
final class ReplyMeViewModel: MessageListViewModel {
    private(set) var loadingState: LoadingState<[MessageItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[MessageItem]>.run {
            let resp: APIResponse<NotifyListData> = try await APIClient.shared.get(
                APIEndpoints.msgReplyMe, params: ["id": "0", "build": "0", "mobi_app": "web"]
            )
            return resp.data?.items?.map { item in
                MessageItem(
                    id: item.id ?? 0,
                    senderName: item.user?.nickname ?? "",
                    content: item.item?.desc ?? "",
                    timeText: Date(timeIntervalSince1970: TimeInterval(item.id ?? 0))
                        .formatted(date: .abbreviated, time: .omitted)
                )
            } ?? []
        }
        loadingState = result
    }
}

// MARK: - AtMeViewModel
@Observable
final class AtMeViewModel: MessageListViewModel {
    private(set) var loadingState: LoadingState<[MessageItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[MessageItem]>.run {
            let resp: APIResponse<NotifyListData> = try await APIClient.shared.get(
                APIEndpoints.msgAt, params: ["id": "0", "build": "0", "mobi_app": "web"]
            )
            return resp.data?.items?.map { item in
                MessageItem(id: item.id ?? 0,
                            senderName: item.user?.nickname ?? "",
                            content: item.item?.title ?? item.item?.desc ?? "",
                            timeText: "")
            } ?? []
        }
        loadingState = result
    }
}

// MARK: - LikeMeViewModel
@Observable
final class LikeMeViewModel: MessageListViewModel {
    private(set) var loadingState: LoadingState<[MessageItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[MessageItem]>.run {
            let resp: APIResponse<LikeNotifyData> = try await APIClient.shared.get(
                APIEndpoints.msgLike, params: ["id": "0", "build": "0", "mobi_app": "web"]
            )
            return resp.data?.latest?.map { item in
                MessageItem(id: item.id ?? 0,
                            senderName: item.likeUsers?.first?.nickname ?? "",
                            content: item.item?.business ?? "",
                            timeText: "")
            } ?? []
        }
        loadingState = result
    }
}

// MARK: - SysMsgViewModel
@Observable
final class SysMsgViewModel: MessageListViewModel {
    private(set) var loadingState: LoadingState<[MessageItem]> = .idle

    func load() async {
        guard case .idle = loadingState else { return }
        loadingState = .loading
        let result = await LoadingState<[MessageItem]>.run {
            let resp: APIResponse<SysMsgData> = try await APIClient.shared.get(
                APIEndpoints.msgSys, params: ["build": "0", "mobi_app": "web", "id": "0"]
            )
            return resp.data?.items?.map { item in
                MessageItem(id: item.id_, senderName: "系统", content: item.title, timeText: "")
            } ?? []
        }
        loadingState = result
    }
}

// MARK: - MainReplyViewModel
@Observable
final class MainReplyViewModel {
    let params: MainReplyParams
    init(params: MainReplyParams) { self.params = params }
}

// MARK: - 通知数据辅助模型
struct NotifyListData: Codable {
    let items: [NotifyMessage]?
    let cursor: NotifyCursor?
    struct NotifyCursor: Codable { let id: Int64?; let time: Int64? }
}
struct LikeNotifyData: Codable {
    let latest: [NotifyMessage]?
    let total: LikeTotal?
    struct LikeTotal: Codable { let latest: [NotifyMessage]?; let me: [NotifyMessage]? }
}
struct SysMsgData: Codable {
    let items: [SysItem]?
    struct SysItem: Codable {
        let id_: Int64
        let title: String
        let content: String?
        let url: String?
        let type: Int?
        enum CodingKeys: String, CodingKey {
            case title, content, url, type
            case id_ = "id"
        }
    }
}
