import Foundation

// MARK: - 通用视频模型
// 映射自 lib/models/model_video.dart 和 lib/models/model_owner.dart

struct VideoOwner: Codable, Hashable {
    let mid: Int64
    let name: String
    let face: String
}

struct VideoStat: Codable, Hashable {
    let view: Int
    let danmaku: Int
    let reply: Int
    let favorite: Int
    let coin: Int
    let share: Int
    let nowRank: Int?
    let hisRank: Int?
    let like: Int
    let dislike: Int?

    enum CodingKeys: String, CodingKey {
        case view, danmaku, reply, favorite, coin, share, like, dislike
        case nowRank = "now_rank"
        case hisRank = "his_rank"
    }
}

struct RightsInfo: Codable, Hashable {
    let bp: Int?
    let elec: Int?
    let download: Int?
    let movie: Int?
    let pay: Int?
    let ugcPay: Int?
    let isCooperation: Int?
    let ugcPayPreview: Int?
    let noReprint: Int?
    let autoplay: Int?

    enum CodingKeys: String, CodingKey {
        case bp, elec, download, movie, pay
        case ugcPay         = "ugc_pay"
        case isCooperation  = "is_cooperation"
        case ugcPayPreview  = "ugc_pay_preview"
        case noReprint      = "no_reprint"
        case autoplay
    }
}

// MARK: - 推荐/热门视频列表项
// 映射自 lib/models/model_rec_video_item.dart 和 model_hot_video_item.dart

struct RecVideoItem: Codable, Identifiable, Hashable {
    var id: Int64 { aid }

    let aid: Int64
    let bvid: String
    let title: String
    let pic: String?                    // 封面 URL（有时为 nil）
    let `desc`: String?
    let owner: VideoOwner
    let stat: VideoStat
    let duration: Int
    let pubdate: Int64?
    let rcmdReason: RcmdReason?         // 推荐理由
    let goto: String?                   // "av", "bangumi", "live" 等
    let uri: String?
    let tid: Int?                       // 分区 ID
    let tname: String?                  // 分区名

    enum CodingKeys: String, CodingKey {
        case aid, bvid, title, pic, desc, owner, stat, duration, pubdate, goto, uri, tid, tname
        case rcmdReason = "rcmd_reason"
    }
}

struct RcmdReason: Codable, Hashable {
    let content: String?
    let reasonType: Int?
    enum CodingKeys: String, CodingKey {
        case content
        case reasonType = "reason_type"
    }
}

// MARK: - 分页游标
struct PageInfo: Codable, Hashable {
    let total: Int?
    let size: Int?
    let num: Int?
    let pageSize: Int?
    enum CodingKeys: String, CodingKey {
        case total, size, num
        case pageSize = "page_size"
    }
}

// MARK: - 用户信息
// 映射自 lib/models_new/account_myinfo/data.dart

struct UserInfoData: Codable {
    let mid: Int64
    let uname: String
    let face: String
    let money: Double?
    let level: Int?
    let vipType: Int?
    let isLogin: Bool?
    let wbiImg: WbiImg?

    enum CodingKeys: String, CodingKey {
        case mid, uname, face, money, level
        case vipType = "vip_type"
        case isLogin = "isLogin"
        case wbiImg  = "wbi_img"
    }

    struct WbiImg: Codable {
        let imgUrl: String
        let subUrl: String
        enum CodingKeys: String, CodingKey {
            case imgUrl = "img_url"
            case subUrl = "sub_url"
        }
    }
}

// MARK: - 成员/UP主信息
// 映射自 lib/models/member/info.dart

struct MemberInfo: Codable {
    let mid: Int64
    let name: String
    let face: String
    let sign: String?
    let sex: String?
    let level: Int?
    let official: OfficialInfo?
    let vip: VipInfo?
    let fans: Int?
    let friend: Int?
    let archive: ArchiveStat?

    struct OfficialInfo: Codable {
        let role: Int?
        let title: String?
        let desc: String?
        let type: Int?
    }

    struct VipInfo: Codable {
        let type: Int?
        let status: Int?
        let label: VipLabel?
        struct VipLabel: Codable {
            let path: String?
            let text: String?
            let labelTheme: String?
            enum CodingKeys: String, CodingKey {
                case path, text
                case labelTheme = "label_theme"
            }
        }
    }

    struct ArchiveStat: Codable {
        let count: Int?
    }
}

// MARK: - 关注列表项
// 映射自 lib/models_new/follow/data.dart

struct FollowItem: Codable, Identifiable, Hashable {
    var id: Int64 { mid }
    let mid: Int64
    let uname: String
    let face: String
    let sign: String?
    let attribute: Int?     // 关注属性：0=未关注 2=已关注 6=互关 128=黑名单
    let mtime: Int64?

    enum CodingKeys: String, CodingKey {
        case mid, uname, face, sign, attribute, mtime
    }
}

// MARK: - 搜索结果
// 映射自 lib/models/search/result.dart

struct SearchResult: Codable {
    let cost: Double?
    let page: Int?
    let pagesize: Int?
    let seid: String?
    let totalResults: Int?
    let result: [SearchResultItem]?

    enum CodingKeys: String, CodingKey {
        case cost, page, pagesize, seid, result
        case totalResults = "numResults"
    }
}

struct SearchResultItem: Codable, Identifiable {
    var id: String { "\(type ?? "")_\(aid ?? 0)" }
    let type: String?
    let aid: Int64?
    let bvid: String?
    let title: String?
    let author: String?
    let mid: Int64?
    let pic: String?
    let `desc`: String?
    let play: Int?
    let danmaku: Int?
    let duration: String?
    let pubdate: Int64?
    let like: Int?
    let uname: String?      // 用户搜索
    let fans: Int?
    let face: String?
    let usignature: String?

    enum CodingKeys: String, CodingKey {
        case type, aid, bvid, title, author, mid, pic, desc, play, danmaku, duration, pubdate, like
        case uname, fans, face
        case usignature = "usign"
    }
}

// MARK: - 动态模型（简化基础结构）
// 映射自 lib/models_new/dynamic/ 系列

struct DynamicItem: Codable, Identifiable, Hashable {
    var id: String { idStr }
    let idStr: String
    let type: String?
    let modules: DynamicModules?
    let orig: DynamicItem?              // 转发原动态

    enum CodingKeys: String, CodingKey {
        case idStr = "id_str"
        case type, modules, orig
    }
}

struct DynamicModules: Codable, Hashable {
    let moduleAuthor: DynamicAuthor?
    let moduleDynamic: DynamicContent?
    let moduleStat: DynamicStat?
    let moduleInteraction: DynamicInteraction?

    enum CodingKeys: String, CodingKey {
        case moduleAuthor    = "module_author"
        case moduleDynamic   = "module_dynamic"
        case moduleStat      = "module_stat"
        case moduleInteraction = "module_interaction"
    }
}

struct DynamicAuthor: Codable, Hashable {
    let mid: Int64
    let name: String
    let face: String
    let pubTs: Int64?
    let pubAction: String?
    enum CodingKeys: String, CodingKey {
        case mid, name, face
        case pubTs     = "pub_ts"
        case pubAction = "pub_action"
    }
}

struct DynamicContent: Codable, Hashable {
    let type: String?
    let major: DynamicMajor?
    let desc: DynamicDesc?
}

struct DynamicMajor: Codable, Hashable {
    let type: String?
    let archive: DynamicArchive?
    let draw: DynamicDraw?
    let live: DynamicLive?

    struct DynamicArchive: Codable, Hashable {
        let aid: String?
        let bvid: String?
        let title: String?
        let cover: String?
        let stat: ArchiveStat?
        struct ArchiveStat: Codable, Hashable {
            let play: String?
            let danmaku: String?
        }
    }

    struct DynamicDraw: Codable, Hashable {
        let id: Int64?
        let items: [DrawItem]?
        struct DrawItem: Codable, Hashable {
            let src: String?
            let width: Int?
            let height: Int?
        }
    }

    struct DynamicLive: Codable, Hashable {
        let id: Int64?
        let title: String?
        let cover: String?
        let liveState: Int?
        enum CodingKeys: String, CodingKey {
            case id, title, cover
            case liveState = "live_state"
        }
    }
}

struct DynamicDesc: Codable, Hashable {
    let text: String?
    let richTextNodes: [RichTextNode]?
    enum CodingKeys: String, CodingKey {
        case text
        case richTextNodes = "rich_text_nodes"
    }
}

struct RichTextNode: Codable, Hashable {
    let type: String?
    let text: String?
    let origText: String?
    let emoji: EmojiNode?
    enum CodingKeys: String, CodingKey {
        case type, text, emoji
        case origText = "orig_text"
    }
    struct EmojiNode: Codable, Hashable {
        let text: String?
        let iconUrl: String?
        enum CodingKeys: String, CodingKey {
            case text
            case iconUrl = "icon_url"
        }
    }
}

struct DynamicStat: Codable, Hashable {
    let comment: DynInteraction?
    let forward: DynInteraction?
    let like: DynInteraction?

    struct DynInteraction: Codable, Hashable {
        let count: Int?
        let forbidden: Bool?
    }
}

struct DynamicInteraction: Codable, Hashable {
    let likeInfo: LikeInfo?
    enum CodingKeys: String, CodingKey {
        case likeInfo = "like_info"
    }
    struct LikeInfo: Codable, Hashable {
        let isLike: Bool?
        enum CodingKeys: String, CodingKey {
            case isLike = "is_like"
        }
    }
}
