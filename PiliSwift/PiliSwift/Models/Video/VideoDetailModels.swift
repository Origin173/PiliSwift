import Foundation

// MARK: - 视频详情
// 映射自 lib/models_new/video/video_detail/data.dart

struct VideoDetail: Codable, Identifiable {
    var id: Int64 { aid }

    let aid: Int64
    let bvid: String
    let title: String
    let pic: String?
    let desc: String?
    let owner: VideoOwner?
    let stat: VideoStat?
    let duration: Int?
    let pubdate: Int64?
    let cid: Int64?
    let pages: [VideoPage]?
    let rights: RightsInfo?
    let ugcSeason: UgcSeason?
    let staff: [VideoStaff]?
    let honorReply: HonorReply?
    let shortLinkV2: String?

    enum CodingKeys: String, CodingKey {
        case aid, bvid, title, pic, desc, owner, stat, duration, pubdate, cid, pages, rights, staff
        case ugcSeason      = "ugc_season"
        case honorReply     = "honor_reply"
        case shortLinkV2    = "short_link_v2"
    }
}

// MARK: - 视频分P
struct VideoPage: Codable, Identifiable, Hashable {
    let cid: Int64
    let page: Int
    let part: String
    let duration: Int

    var id: Int64 { cid }
}

// MARK: - 合集
struct UgcSeason: Codable, Hashable {
    let id: Int64?
    let title: String?
    let cover: String?
    let sections: [UgcSection]?

    struct UgcSection: Codable, Hashable {
        let id: Int64?
        let title: String?
        let episodes: [UgcEpisode]?
    }

    struct UgcEpisode: Codable, Hashable, Identifiable {
        var id: Int64 { aid }
        let aid: Int64
        let bvid: String
        let title: String?
        let arc: VideoArc?

        struct VideoArc: Codable, Hashable {
            let pic: String?
            let stat: VideoStat?
        }
    }
}

// MARK: - 联合投稿人
struct VideoStaff: Codable, Hashable, Identifiable {
    var id: Int64 { mid }
    let mid: Int64
    let title: String
    let name: String
    let face: String
}

// MARK: - 荣誉
struct HonorReply: Codable, Hashable {
    let honor: [HonorItem]?
    struct HonorItem: Codable, Hashable {
        let aid: Int64
        let type: Int?
        let desc: String?
        let weeklyRecommendNum: Int?
        enum CodingKeys: String, CodingKey {
            case aid, type, desc
            case weeklyRecommendNum = "weekly_recommend_num"
        }
    }
}

// MARK: - 视频播放地址
// 映射自 lib/models_new/video/video_play_info/data.dart

struct VideoPlayInfo: Codable {
    let quality: Int?
    let format: String?
    let timelength: Int?
    let acceptFormat: String?
    let acceptDescription: [String]?
    let acceptQuality: [Int]?
    let videoCodecid: Int?
    let seekParam: String?
    let seekType: String?
    let dash: VideoDash?
    let supportFormats: [SupportFormat]?

    enum CodingKeys: String, CodingKey {
        case quality, format, timelength, dash
        case acceptFormat       = "accept_format"
        case acceptDescription  = "accept_description"
        case acceptQuality      = "accept_quality"
        case videoCodecid       = "video_codecid"
        case seekParam          = "seek_param"
        case seekType           = "seek_type"
        case supportFormats     = "support_formats"
    }
}

struct VideoDash: Codable {
    let duration: Int?
    let minBufferTime: Double?
    let video: [DashStream]?
    let audio: [DashStream]?
    let flac: FlacStream?
    let dolby: DolbyStream?
    enum CodingKeys: String, CodingKey {
        case duration, video, audio, flac, dolby
        case minBufferTime = "min_buffer_time"
    }
}

struct DashStream: Codable, Identifiable {
    var id: Int { codecid ?? 0 }
    let id_: Int?
    let baseUrl: String
    let backupUrl: [String]?
    let bandwidth: Int?
    let mimeType: String?
    let codecs: String?
    let width: Int?
    let height: Int?
    let frameRate: String?
    let codecid: Int?
    enum CodingKeys: String, CodingKey {
        case bandwidth, codecs, width, height, codecid
        case id_        = "id"
        case baseUrl    = "base_url"
        case backupUrl  = "backup_url"
        case mimeType   = "mime_type"
        case frameRate  = "frame_rate"
    }
}

struct FlacStream: Codable {
    let audio: DashStream?
}

struct DolbyStream: Codable {
    let type: Int?
    let audio: [DashStream]?
}

struct SupportFormat: Codable {
    let quality: Int?
    let format: String?
    let description: String?
    let newDescription: String?
    let displayDesc: String?
    let superscript: String?
    let codecs: [String]?
    enum CodingKeys: String, CodingKey {
        case quality, format, description, codecs, superscript
        case newDescription = "new_description"
        case displayDesc    = "display_desc"
    }
}
