import Foundation

// MARK: - 番剧 Season
// 映射自 lib/models_new/pgc/pgc_detail/data.dart

struct PGCSeason: Codable, Identifiable {
    var id: Int64 { seasonId ?? 0 }

    let seasonId: Int64?
    let mediaId: Int64?
    let title: String?
    let cover: String?
    let squareCover: String?
    let evaluate: String?
    let type: Int?
    let episodes: [PGCEpisode]?
    let seasons: [PGCSeason]?   // 相关季度
    let sections: [PGCSection]?
    let stat: PGCStat?

    enum CodingKeys: String, CodingKey {
        case title, cover, evaluate, type, episodes, seasons, sections, stat
        case seasonId    = "season_id"
        case mediaId     = "media_id"
        case squareCover = "square_cover"
    }
}

// MARK: - 番剧剧集
struct PGCEpisode: Codable, Identifiable, Hashable {
    var id: Int64 { epId ?? 0 }

    let epId: Int64?
    let aid: Int64?
    let bvid: String?
    let cid: Int64?
    let title: String?
    let longTitle: String?
    let cover: String?
    let index: Int?
    let indexTitle: String?
    let duration: Int?
    let badge: String?
    let from: String?
    let episodeId: Int64?

    enum CodingKeys: String, CodingKey {
        case aid, bvid, cid, title, cover, index, duration, badge, from
        case epId       = "ep_id"
        case longTitle  = "long_title"
        case indexTitle = "index_title"
        case episodeId  = "episode_id"
    }
}

// MARK: - 番剧分区节
struct PGCSection: Codable, Identifiable {
    var id: Int { type ?? 0 }
    let type: Int?
    let title: String?
    let episodes: [PGCEpisode]?
}

// MARK: - 番剧统计
struct PGCStat: Codable {
    let fans: Int?
    let views: Int?
    let seriesFollow: Int?
    let seasonFollow: Int?
    let reply: Int?
    enum CodingKeys: String, CodingKey {
        case fans, views, reply
        case seriesFollow = "series_follow"
        case seasonFollow = "season_follow"
    }
}

// MARK: - 追番列表项
// 映射自 lib/models_new/pgc/follow_list/data.dart

struct SubscriptionSeason: Codable, Identifiable, Hashable {
    var id: Int64 { seasonId ?? 0 }

    let seasonId: Int64?
    let mediaId: Int64?
    let title: String?
    let cover: String?
    let newDesc: String?
    let newEpDesc: String?
    let progress: SubscriptionProgress?
    let badge: String?
    let badgeType: Int?
    let square_cover: String?
    let url: String?

    struct SubscriptionProgress: Codable, Hashable {
        let lastEpId: Int64?
        let lastEpIndex: String?
        let lastTime: Int64?
        enum CodingKeys: String, CodingKey {
            case lastEpId    = "last_ep_id"
            case lastEpIndex = "last_ep_index"
            case lastTime    = "last_time"
        }
    }

    enum CodingKeys: String, CodingKey {
        case title, cover, badge, url
        case seasonId    = "season_id"
        case mediaId     = "media_id"
        case newDesc     = "new_desc"
        case newEpDesc   = "new_ep_desc"
        case progress
        case badgeType   = "badge_type"
        case square_cover
    }
}
