import Foundation

// MARK: - 路由枚举
// 映射自 lib/router/app_pages.dart 中的 115+ 路由

enum Route: Hashable {
    // MARK: - 视频
    case videoDetail(VideoDetailParams)
    case audio(Int64)                           // aid/bvid

    // MARK: - 用户空间
    case member(Int64)                          // mid
    case memberHome(Int64)
    case memberDynamics(Int64)
    case memberVideo(Int64)
    case memberAudio(Int64)
    case memberArticle(Int64)
    case memberOpus(Int64)
    case memberPgc(Int64)
    case memberSeason(Int64)
    case memberSearch(Int64)
    case memberGuard(Int64)
    case memberShop(Int64)
    case memberFavorite(Int64)
    case memberCheese(Int64)
    case memberComic(Int64)
    case memberUpowerRank(Int64)
    case memberContribute(Int64)
    case memberProfile
    case upowerRank(Int64)
    case spaceSetting

    // MARK: - 搜索
    case search
    case searchResult(String)                   // keyword
    case searchTrending

    // MARK: - 动态
    case dynamicDetail(String)                  // dynamic id
    case dynamicsTopic(String)                  // topic name
    case dynTopicRcmd

    // MARK: - 主导航 Tab（也可被 push）
    case hot
    case rank
    case live
    case liveRoom(Int64)                        // roomId
    case liveArea
    case liveAreaDetail(Int64, String)          // parentId, areaName

    // MARK: - 收藏
    case fav(Int64)                             // mid
    case favDetail(Int64, String)               // mediaId, title

    // MARK: - 历史 & 稍后再看
    case history
    case later

    // MARK: - 关注 & 粉丝
    case follow(Int64)                          // mid
    case followed(Int64)
    case fan(Int64)
    case followSearch(Int64)
    case sameFollowing(Int64)

    // MARK: - 消息
    case whisper
    case whisperDetail(Int64)                   // talkerId
    case replyMe
    case atMe
    case likeMe
    case sysMsg
    case myReply
    case mainReply(MainReplyParams)

    // MARK: - PGC / 番剧
    case pgc(Int64)                             // seasonId
    case pgcIndex
    case pgcReview(Int64)                       // seasonId
    case subscription
    case subscription_detail(Int64)             // seasonId

    // MARK: - 设置
    case setting
    case recommendSetting
    case videoSetting
    case playSetting
    case styleSetting
    case privacySetting
    case extraSetting
    case colorSetting
    case fontSizeSetting
    case barSetting
    case settingsSearch

    // MARK: - 其他
    case login
    case about
    case article(Int64)                         // article id
    case articleList(Int64)                     // mid
    case download
    case webview(URL)
    case blacklist
    case danmakuBlock
    case sponsorBlock
    case music
    case dlna
    case webdav
    case matchInfo(String)                      // match id
    case popularSeries
    case popularPrecious
    case loginDevices
    case logs
}

// MARK: - 路由参数结构体

struct VideoDetailParams: Hashable {
    var bvid: String?
    var aid: Int64?
    var cid: Int64?
    var epId: Int64?            // PGC episode id
    var seasonId: Int64?        // PGC season id
    var isLocal: Bool = false   // 本地文件播放
    var startTime: Int = 0
}

struct MainReplyParams: Hashable {
    let replyType: Int
    let oid: Int64
    var sortType: Int = 0
}
