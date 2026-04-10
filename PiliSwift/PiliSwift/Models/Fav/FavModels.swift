import Foundation

// MARK: - 收藏夹
// 映射自 lib/models/fav/fav_folder.dart

struct FavFolder: Codable, Identifiable, Hashable {
    var id: Int64 { mediaId ?? fid ?? 0 }

    let mediaId: Int64?
    let fid: Int64?
    let mid: Int64?
    let title: String?
    let cover: String?
    let attr: Int?
    let mediaCount: Int?
    let isFaved: Bool?

    // 以下字段用于收藏夹详情
    let type: Int?    // 收藏类型 11=视频 21=音频

    enum CodingKeys: String, CodingKey {
        case fid, mid, title, cover, attr, type
        case mediaId    = "id"
        case mediaCount = "media_count"
        case isFaved    = "fav_state"
    }

    // Custom decode to handle fav_state as Int
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        mediaId     = try c.decodeIfPresent(Int64.self, forKey: .mediaId)
        fid         = try c.decodeIfPresent(Int64.self, forKey: .fid)
        mid         = try c.decodeIfPresent(Int64.self, forKey: .mid)
        title       = try c.decodeIfPresent(String.self, forKey: .title)
        cover       = try c.decodeIfPresent(String.self, forKey: .cover)
        attr        = try c.decodeIfPresent(Int.self, forKey: .attr)
        mediaCount  = try c.decodeIfPresent(Int.self, forKey: .mediaCount)
        type        = try c.decodeIfPresent(Int.self, forKey: .type)
        // fav_state is 0/1
        let favState = try c.decodeIfPresent(Int.self, forKey: .isFaved)
        isFaved = favState == 1
    }
}

// MARK: - 收藏夹中的视频列表响应
struct FavDetailResponse: Codable {
    let info: FavFolder?
    let medias: [FavMedia]?

    struct FavMedia: Codable, Identifiable {
        var id: Int64 { Int64(bvid.hashValue) }
        let bvid: String
        let title: String?
        let cover: String?
        let upper: FavUpper?
        let cntInfo: CntInfo?
        let duration: Int?
        let pubdate: Int64?

        var asRecVideoItem: RecVideoItem {
            RecVideoItem(
                aid: 0,
                bvid: bvid,
                title: title ?? "",
                pic: cover,
                desc: nil,
                owner: VideoOwner(mid: upper?.mid ?? 0, name: upper?.name ?? "", face: upper?.face ?? ""),
                stat: VideoStat(view: cntInfo?.play ?? 0, danmaku: cntInfo?.danmaku ?? 0,
                                reply: 0, favorite: 0, coin: 0, share: 0,
                                nowRank: nil, hisRank: nil, like: 0, dislike: nil),
                duration: duration ?? 0,
                pubdate: pubdate,
                rcmdReason: nil,
                goto: "av",
                uri: nil,
                tid: nil,
                tname: nil
            )
        }

        enum CodingKeys: String, CodingKey {
            case bvid, title, cover, upper, duration, pubdate
            case cntInfo = "cnt_info"
        }

        struct FavUpper: Codable {
            let mid: Int64
            let name: String?
            let face: String?
        }

        struct CntInfo: Codable {
            let play: Int?
            let danmaku: Int?
            let reply: Int?
            let collect: Int?
        }
    }
}
