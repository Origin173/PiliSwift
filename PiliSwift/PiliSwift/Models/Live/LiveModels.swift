import Foundation

// MARK: - 直播间信息
// 映射自 lib/http/live.dart 相关模型

struct LiveRoomItem: Codable, Identifiable, Hashable {
    var id: Int64 { roomId }

    let roomId: Int64
    let uid: Int64?
    let title: String?
    let cover: String?
    let userCover: String?
    let keyFrame: String?
    let uname: String?
    let face: String?
    let areaId: Int?
    let areaName: String?
    let parentAreaId: Int?
    let parentAreaName: String?
    let onlineHidden: Int?
    let online: Int?
    let liveStatus: Int?       // 1 = 直播中
    let liveStartTime: Int64?
    let roomScore: Int?

    enum CodingKeys: String, CodingKey {
        case uid, title, cover, uname, face, online
        case roomId         = "room_id"
        case userCover      = "user_cover"
        case keyFrame       = "keyframe"
        case areaId         = "area_id"
        case areaName       = "area_name"
        case parentAreaId   = "parent_area_id"
        case parentAreaName = "parent_area_name"
        case onlineHidden   = "online_hidden"
        case liveStatus     = "live_status"
        case liveStartTime  = "live_start_time"
        case roomScore      = "room_score"
    }
}

// MARK: - 直播间详情
struct LiveRoomDetail: Codable {
    let roomId: Int64?
    let uid: Int64?
    let title: String?
    let cover: String?
    let tags: String?
    let liveStatus: Int?
    let liveStartTime: Int64?
    let description: String?
    let areaId: Int?
    let areaName: String?
    let parentAreaId: Int?
    let parentAreaName: String?

    enum CodingKeys: String, CodingKey {
        case uid, title, cover, tags, description
        case roomId         = "room_id"
        case liveStatus     = "live_status"
        case liveStartTime  = "live_start_time"
        case areaId         = "area_id"
        case areaName       = "area_name"
        case parentAreaId   = "parent_area_id"
        case parentAreaName = "parent_area_name"
    }
}

// MARK: - 直播弹幕
struct LiveDanmaku: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    let content: String
    let userId: Int64?
    let userName: String?
    let color: Int?
    let timestamp: Int64?

    enum CodingKeys: String, CodingKey {
        case content = "text"
        case userId = "uid"
        case userName = "uname"
        case color = "color"
        case timestamp = "ts"
    }

    init(content: String, userId: Int64? = nil, userName: String? = nil,
         color: Int? = nil, timestamp: Int64? = nil) {
        self.content = content
        self.userId = userId
        self.userName = userName
        self.color = color
        self.timestamp = timestamp
    }
}

// MARK: - 直播播放流信息
struct LivePlayInfo: Codable {
    let currentQuality: Int?
    let acceptQuality: [String]?
    let currentQualityName: String?
    let durl: [LiveStreamUrl]?

    struct LiveStreamUrl: Codable {
        let url: String
        let length: Int?
        let order: Int?
        let streamType: Int?
        let ptpType: Int?
        enum CodingKeys: String, CodingKey {
            case url, length, order
            case streamType = "stream_type"
            case ptpType    = "p2p_type"
        }
    }

    enum CodingKeys: String, CodingKey {
        case durl
        case currentQuality     = "current_quality"
        case acceptQuality      = "accept_quality"
        case currentQualityName = "current_qn_name"
    }
}
