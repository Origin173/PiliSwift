import Foundation

// MARK: - 路由枚举
// 映射自 lib/router/app_pages.dart 中的 115+ 路由

enum Route: Hashable {
    // MARK: - 视频
    case videoDetail(VideoDetailParams)
    case audio(aid: Int64)                      // aid/bvid

    // MARK: - 用户空间
    case member(mid: Int64)
    case memberHome(mid: Int64)
    case memberDynamics(mid: Int64)
    case memberVideo(mid: Int64)
    case memberAudio(mid: Int64)
    case memberArticle(mid: Int64)
    case memberOpus(mid: Int64)
    case memberPgc(mid: Int64)
    case memberSeason(mid: Int64)
    case memberSearch(mid: Int64)
    case memberGuard(mid: Int64)
    case memberShop(mid: Int64)
    case memberFavorite(mid: Int64)
    case memberCheese(mid: Int64)
    case memberComic(mid: Int64)
    case memberUpowerRank(mid: Int64)
    case memberContribute(mid: Int64)
    case memberProfile
    case upowerRank(mid: Int64)
    case spaceSetting

    // MARK: - 搜索
    case search
    case searchResult(keyword: String)
    case searchTrending

    // MARK: - 动态
    case dynamicDetail(String)                  // dynamic id
    case dynamicsTopic(String)                  // topic name
    case dynTopicRcmd

    // MARK: - 主导航 Tab（也可被 push）
    case hot
    case rank
    case live
    case liveRoom(roomId: Int64)
    case liveArea
    case liveAreaDetail(parentId: Int64, areaName: String)

    // MARK: - 收藏
    case fav(mid: Int64)
    case favDetail(id: Int64, title: String)

    // MARK: - 历史 & 稍后再看
    case history
    case later

    // MARK: - 关注 & 粉丝
    case follow(mid: Int64)
    case followed(mid: Int64)
    case fan(mid: Int64)
    case followSearch(mid: Int64)
    case sameFollowing(mid: Int64)

    // MARK: - 消息
    case whisper
    case whisperDetail(talkerId: Int64)
    case replyMe
    case atMe
    case likeMe
    case sysMsg
    case myReply
    case mainReply(params: MainReplyParams)

    // MARK: - PGC / 番剧
    case pgc(seasonId: Int64)
    case pgcIndex
    case pgcReview(seasonId: Int64)
    case subscription
    case subscription_detail(seasonId: Int64)

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
    case article(id: Int64)
    case articleList(mid: Int64)
    case download
    case webview(url: URL)
    case blacklist
    case danmakuBlock
    case sponsorBlock
    case music
    case dlna
    case webdav
    case matchInfo(id: String)
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
