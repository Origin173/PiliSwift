import Foundation

// MARK: - 私信会话
// 映射自 lib/http/msg.dart 相关模型

struct WhisperSession: Codable, Identifiable, Hashable {
    var id: Int64 { talkerId }

    let talkerId: Int64
    let talkerFid: String?
    let sessionType: Int?
    let unreadCount: Int?
    let lastContent: String?
    let lastTimestamp: Int64?
    let talkerName: String?
    let talkerFace: String?
    let isFollow: Bool?

    enum CodingKeys: String, CodingKey {
        case talkerId       = "talker_id"
        case talkerFid      = "talker_fid"
        case sessionType    = "session_type"
        case unreadCount    = "unread_count"
        case lastContent    = "last_content"
        case lastTimestamp  = "last_timestamp"
        case talkerName     = "account_info_talker_name"
        case talkerFace     = "account_info_talker_face"
        case isFollow       = "is_follow"
    }
}

// MARK: - 私信消息
struct WhisperMessage: Codable, Identifiable, Hashable {
    var id: Int64 { msgId ?? 0 }

    let msgId: Int64?
    let senderUid: Int64?
    let receiverUid: Int64?
    let content: String
    let msgType: Int?
    let timestamp: Int64?
    var isMine: Bool = false

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case msgId          = "msg_id"
        case senderUid      = "sender_uid"
        case receiverUid    = "receiver_id"
        case msgType        = "msg_type"
        case timestamp      = "timestamp"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        msgId       = try c.decodeIfPresent(Int64.self, forKey: .msgId)
        senderUid   = try c.decodeIfPresent(Int64.self, forKey: .senderUid)
        receiverUid = try c.decodeIfPresent(Int64.self, forKey: .receiverUid)
        msgType     = try c.decodeIfPresent(Int.self, forKey: .msgType)
        timestamp   = try c.decodeIfPresent(Int64.self, forKey: .timestamp)
        // content 可能是嵌套 JSON 字符串，先解为 String
        content = (try? c.decode(String.self, forKey: .content)) ?? ""
        isMine = false  // 由外部赋值
    }
}

// MARK: - 通知消息
struct NotifyMessage: Codable, Identifiable {
    var id: Int64 { id_ ?? 0 }
    let id_: Int64?
    let user: NotifyUser?
    let item: NotifyItem?
    let likeUsers: [LikeUser]?
    let counts: Int?
    let atDetails: [AtDetail]?

    struct NotifyUser: Codable {
        let mid: Int64?
        let avatar: String?
        let nickname: String?
    }

    struct NotifyItem: Codable {
        let subjectId: Int64?
        let rootId: Int64?
        let targetId: Int64?
        let type: String?
        let business: String?
        let businessId: String?
        let title: String?
        let desc: String?
        let image: String?
        enum CodingKeys: String, CodingKey {
            case type, business, title, desc, image
            case subjectId  = "subject_id"
            case rootId     = "root_id"
            case targetId   = "target_id"
            case businessId = "business_id"
        }
    }

    struct LikeUser: Codable {
        let mid: Int64?
        let avatar: String?
        let nickname: String?
    }

    struct AtDetail: Codable {
        let mid: Int64?
        let nickname: String?
        let avatar: String?
    }

    enum CodingKeys: String, CodingKey {
        case user, item, counts
        case id_        = "id"
        case likeUsers  = "like_users"
        case atDetails  = "at_details"
    }
}
