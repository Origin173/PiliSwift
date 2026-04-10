import Foundation

// MARK: - Bilibili API 端点
// 映射自 lib/http/api.dart 和 lib/http/constants.dart

enum BaseURL {
    static let api          = "https://api.bilibili.com"
    static let app          = "https://app.bilibili.com"
    static let live         = "https://api.live.bilibili.com"
    static let passport     = "https://passport.bilibili.com"
    static let message      = "https://message.bilibili.com"
    static let t            = "https://api.vc.bilibili.com"
    static let space        = "https://space.bilibili.com"
    static let account      = "https://account.bilibili.com"
    static let mall         = "https://mall.bilibili.com"
    static let sponsorBlock = "https://www.bsbsb.top"
    static let base         = "https://www.bilibili.com"
    static let dynamicShare = "https://t.bilibili.com"
    static let search       = "https://s.search.bilibili.com"
}

enum Endpoints {
    // MARK: - 推荐视频
    static let recommendListApp = "\(BaseURL.app)/x/v2/feed/index"
    static let recommendListWeb = "/x/web-interface/wbi/index/top/feed/rcmd"
    static let feedDislike      = "\(BaseURL.app)/x/feed/dislike"
    static let feedDislikeCancel = "\(BaseURL.app)/x/feed/dislike/cancel"

    // MARK: - 热门
    static let hotList          = "/x/web-interface/popular"

    // MARK: - 视频流
    static let ugcUrl           = "/x/player/wbi/playurl"
    static let pgcUrl           = "/pgc/player/web/v2/playurl"
    static let pugvUrl          = "/pugv/player/web/playurl"
    static let tvPlayUrl        = "/x/tv/playurl"

    // MARK: - 视频详情
    static let videoIntro       = "/x/web-interface/view"
    static let playInfo         = "/x/player/wbi/v2"

    // MARK: - 视频操作
    static let likeVideoApp     = "\(BaseURL.app)/x/v2/view/like"
    static let dislikeVideoApp  = "\(BaseURL.app)/x/v2/view/dislike"
    static let addCoinApp       = "\(BaseURL.app)/x/v2/view/coin/add"
    static let tripleUgc        = "/x/web-interface/archive/like/triple"
    static let triplePgc        = "/pgc/season/episode/like/triple"
    static let videoRelation    = "/x/web-interface/archive/relation"

    // MARK: - 相关视频
    static let relatedVideos    = "/x/web-interface/archive/related"

    // MARK: - 收藏
    static let favResourceList        = "/x/v3/fav/resource/list"
    static let favResourceBatchDeal   = "/x/v3/fav/resource/batch-deal"
    static let favResourceUnfavAll    = "/x/v3/fav/resource/unfav-all"
    static let favResourceCopy        = "/x/v3/fav/resource/copy"
    static let favResourceMove        = "/x/v3/fav/resource/move"
    static let favResourceClean       = "/x/v3/fav/resource/clean"
    static let favResourceSort        = "/x/v3/fav/resource/sort"
    static let favFolderSort          = "/x/v3/fav/folder/sort"
    static let favFolderListAll       = "/x/v3/fav/folder/created/list-all"
    static let favFolderInfo          = "/x/v3/fav/folder/info"
    static let favFolderAdd           = "/x/v3/fav/folder/add"
    static let favFolderEdit          = "/x/v3/fav/folder/edit"
    static let favFolderDel           = "/x/v3/fav/folder/del"
    static let favSeasonFav           = "/x/v3/fav/season/fav"
    static let favSeasonUnfav         = "/x/v3/fav/season/unfav"
    static let favFolderSpace         = "/x/v3/fav/folder/space"
    static let favFolderUnfav         = "/x/v3/fav/folder/unfav"
    static let favFolderFav           = "/x/v3/fav/folder/fav"
    static let favFolderCollectedList = "/x/v3/fav/folder/collected/list"

    // MARK: - 关注 / Relation
    static let relation           = "/x/relation"
    static let relations          = "/x/relation/relations"
    static let relationModify     = "/x/relation/modify"
    static let relationStat       = "/x/relation/stat"
    static let followings         = "/x/relation/followings"
    static let followingSearch    = "/x/relation/followings/search"
    static let fans               = "/x/relation/fans"
    static let followedUpper      = "/x/relation/followings/followed_upper"
    static let sameFollowing      = "/x/relation/same/followings"

    // MARK: - 分组标签
    static let relationTags       = "/x/relation/tags"
    static let relationTagsAdd    = "/x/relation/tags/addUsers"
    static let tagSpecialAdd      = "/x/relation/tag/special/add"
    static let tagSpecialDel      = "/x/relation/tag/special/del"
    static let relationTag        = "/x/relation/tag"
    static let tagCreate          = "/x/relation/tag/create"
    static let tagUpdate          = "/x/relation/tag/update"
    static let tagDel             = "/x/relation/tag/del"

    // MARK: - 评论
    static let replyList          = "/x/v2/reply"
    static let replyReply         = "/x/v2/reply/reply"
    static let replyAction        = "/x/v2/reply/action"
    static let replyHate          = "/x/v2/reply/hate"
    static let replyAdd           = "/x/v2/reply/add"
    static let replyDel           = "/x/v2/reply/del"
    static let replyTop           = "/x/v2/reply/top"
    static let replyInteractionStatus = "/x/v2/reply/subject/interaction-status"
    static let replyModify        = "/x/v2/reply/subject/modify"

    // MARK: - 用户信息
    static let userInfo           = "/x/web-interface/nav"
    static let userStat           = "/x/web-interface/nav/stat"
    static let memberInfo         = "/x/space/wbi/acc/info"
    static let memberCard         = "/x/web-interface/card"
    static let memberUpStat       = "/x/space/upstat"

    // MARK: - 用户空间
    static let spaceApp           = "\(BaseURL.app)/x/v2/space"
    static let spaceArchiveCursor = "\(BaseURL.app)/x/v2/space/archive/cursor"
    static let spaceStoryCursor   = "\(BaseURL.app)/x/v2/feed/index/space/story/cursor"
    static let spaceSeasonVideos  = "\(BaseURL.app)/x/v2/space/season/videos"
    static let spaceSeries        = "\(BaseURL.app)/x/v2/space/series"
    static let spaceBangumi       = "\(BaseURL.app)/x/v2/space/bangumi"
    static let spaceArticle       = "\(BaseURL.app)/x/v2/space/article"
    static let spaceComic         = "\(BaseURL.app)/x/v2/space/comic"
    static let spaceArcSearch     = "/x/space/wbi/arc/search"
    static let memberSeasons      = "/x/polymer/web-space/home/seasons_series"
    static let seasonArchives     = "/x/polymer/web-space/seasons_archives_list"
    static let seriesArchives     = "/x/series/archives"
    static let spaceTopArc        = "/x/space/top/arc"
    static let spaceCoinVideo     = "/x/space/coin/video"
    static let spaceLikeVideo     = "/x/space/like/video"
    static let spaceArcCharging   = "\(BaseURL.app)/x/v2/space/archive/charging"
    static let spaceFavSeasonList = "/x/space/fav/season/list"
    static let spaceAudio         = "/audio/music-service/web/song/upper"
    static let spaceCheese        = "/pugv/app/web/season/page"
    static let spaceSetting       = "/x/space/setting/app"
    static let spacePrivacyModify = "/x/space/privacy/batch/modify"
    static let spaceReserve       = "/x/space/reserve"
    static let spaceReserveCancel = "/x/space/reserve/cancel"
    static let memberCheeseWeb    = "/pugv/app/web/favorite/page"
    static let memberFavorite     = "/x/space/fav/season/list"

    // MARK: - 搜索
    static let searchDefault      = "/x/web-interface/wbi/search/default"
    static let searchByType       = "/x/web-interface/wbi/search/type"
    static let searchAll          = "/x/web-interface/wbi/search/all/v2"
    static let searchSuggest      = "\(BaseURL.search)/main/suggest"
    static let searchHotWord      = "\(BaseURL.search)/main/hotword"
    static let searchTrending     = "/x/v2/search/trending/ranking"
    static let historySearch      = "/x/web-interface/history/search"

    // MARK: - 历史记录
    static let historyList        = "/x/web-interface/history/cursor"
    static let watchLaterList     = "/x/v2/history/toview/web"
    static let watchLaterAdd      = "/x/v2/history/toview/add"
    static let watchLaterDel      = "/x/v2/history/toview/v2/dels"
    static let watchLaterClear    = "/x/v2/history/toview/clear"
    static let watchLaterCopy     = "/x/v2/history/toview/copy"
    static let watchLaterMove     = "/x/v2/history/toview/move"
    static let historyShadowSet   = "/x/v2/history/shadow/set"
    static let historyShadow      = "/x/v2/history/shadow"
    static let historyClear       = "/x/v2/history/clear"
    static let historyDelete      = "/x/v2/history/delete"
    static let mediaListHistory   = "/x/v1/medialist/history"

    // MARK: - 表情
    static let emotePanel         = "/x/emote/user/panel/web"

    // MARK: - 消息 (Message)
    static let singleUnread       = "/session_svr/v1/session_svr/single_unread"
    static let msgFeedUnread      = "/x/msgfeed/unread"
    static let msgFeedReply       = "/x/msgfeed/reply"
    static let msgFeedAt          = "/x/msgfeed/at"
    static let msgFeedLike        = "/x/msgfeed/like"
    static let msgFeedLikeDetail  = "/x/msgfeed/like_detail"
    static let msgFeedNotice      = "/x/msgfeed/notice"
    static let sessionList        = "/session_svr/v1/session_svr/get_sessions"
    static let sessionAccounts    = "/account/v1/user/cards"
    static let sessionMessages    = "/svr_sync/v1/svr_sync/fetch_session_msgs"
    static let sessionUpdateAck   = "/session_svr/v1/session_svr/update_ack"
    static let sendMsg            = "/web_im/v1/web_im/send_msg"
    static let removeSession      = "/session_svr/v1/session_svr/remove_session"
    static let sessionSetTop      = "/session_svr/v1/session_svr/set_top"
    static let setMsgDnd          = "/link_setting/v1/link_setting/set_msg_dnd"
    static let getSessionSS       = "/link_setting/v1/link_setting/get_session_ss"
    static let getMsgDnd          = "/link_setting/v1/link_setting/get_msg_dnd"
    static let setPushSS          = "/link_setting/v1/link_setting/set_push_ss"
    static let imUserInfos        = "/x/im/user_infos"
    static let imReport           = "/x/bplus/im/report/add"

    // MARK: - 系统消息
    static let sysNotifyList      = "/x/sys-msg/query_notify_list"
    static let sysNotifyCursor    = "/x/sys-msg/update_cursor"
    static let sysNotifyDel       = "/x/sys-msg/del_notify_list"

    // MARK: - 动态
    static let dynFeedAll         = "/x/polymer/web-dynamic/v1/feed/all"
    static let dynUpList          = "/x/polymer/web-dynamic/v1/uplist"
    static let dynPortal          = "/x/polymer/web-dynamic/v1/portal"
    static let dynThumb           = "/x/dynamic/feed/dyn/thumb"
    static let dynDetail          = "/x/polymer/web-dynamic/v1/detail"
    static let dynSpaceFeed       = "/x/polymer/web-dynamic/v1/feed/space"
    static let dynSpaceSearch     = "/x/polymer/web-dynamic/v1/feed/space/search"
    static let dynCreate          = "/x/dynamic/feed/create/dyn"
    static let dynCreateText      = "/dynamic_svr/v1/dynamic_svr/create"
    static let dynRemove          = "/x/dynamic/feed/operate/remove"
    static let dynUploadBfs       = "/x/dynamic/feed/draw/upload_bfs"
    static let dynSetTop          = "/x/dynamic/feed/space/set_top"
    static let dynRmTop           = "/x/dynamic/feed/space/rm_top"
    static let dynPubSetting      = "/x/dynamic/feed/dyn/private_pub_setting"
    static let dynEdit            = "/x/dynamic/feed/edit/dyn"
    static let dynReport          = "/x/dynamic/feed/dynamic_report/add"
    static let opusFav            = "/x/polymer/web-dynamic/v1/opus/feed/fav"
    static let opusDetail         = "/x/polymer/web-dynamic/v1/opus/detail"
    static let opusSpaceFeed      = "/x/polymer/web-dynamic/v1/opus/feed/space"
    static let dynTopicFeed       = "/x/polymer/web-dynamic/v1/feed/topic"
    static let dynMentionSearch   = "/x/polymer/web-dynamic/v1/mention/search"
    static let dynEntrance        = "/x/web-interface/dynamic/entrance"

    // MARK: - 话题
    static let topicTop            = "/x/topic/web/details/top"
    static let topicRankList       = "/x/topic/web/rank/list"
    static let topicLike           = "/x/topic/like"
    static let topicFavList        = "/x/topic/fav/list"
    static let topicFavSubAdd      = "/x/topic/fav/sub/add"
    static let topicFavSubCancel   = "/x/topic/fav/sub/cancel"
    static let topicPubSearch      = "/x/topic/pub/search"
    static let topicWebFavList     = "/x/topic/web/fav/list"
    static let topicDynamicRcmd    = "/x/topic/web/dynamic/rcmd"

    // MARK: - 番剧/PGC
    static let pgcSeasonInfo       = "/pgc/view/web/season"
    static let pgcEpisodeInfo      = "/pgc/season/episode/web/info"
    static let pgcFollowAdd        = "/pgc/web/follow/add"
    static let pgcFollowDel        = "/pgc/web/follow/del"
    static let pgcFollowStatusUpdate = "/pgc/web/follow/status/update"
    static let pgcFollowList       = "/x/space/bangumi/follow/list"
    static let pgcTimeline         = "/pgc/web/timeline"
    static let pgcSeasonRank       = "/pgc/season/rank/web/list"
    static let pgcEpCommunity      = "/pgc/season/episode/community"
    static let pgcReviewLong       = "/pgc/review/long/list"
    static let pgcReviewShort      = "/pgc/review/short/list"
    static let pgcReviewLike       = "/pgc/review/action/like"
    static let pgcReviewDislike    = "/pgc/review/action/dislike"
    static let pgcReviewPost       = "/pgc/review/short/post"
    static let pgcReviewModify     = "/pgc/review/short/modify"
    static let pgcReviewDel        = "/pgc/review/short/del"
    static let pgcIndexCondition   = "/pgc/season/index/condition"
    static let pgcIndexResult      = "/pgc/season/index/result"
    static let pgcSeasonStatus     = "/pgc/view/web/season/user/status"
    static let pugvInfo            = "/pugv/view/web/season"
    static let pugvFavPage         = "/pugv/app/web/favorite/page"
    static let pugvFavAdd          = "/pugv/app/web/favorite/add"
    static let pugvFavDel          = "/pugv/app/web/favorite/del"

    // MARK: - 直播
    static let liveUserRcmd        = "\(BaseURL.live)/xlive/web-interface/v1/second/getUserRecommend"
    static let liveRoomPlayInfo    = "\(BaseURL.live)/xlive/web-room/v2/index/getRoomPlayInfo"
    static let liveRoomInfoH5      = "\(BaseURL.live)/xlive/web-room/v1/index/getH5InfoByRoom"
    static let liveDmHistory       = "\(BaseURL.live)/xlive/web-room/v1/dM/gethistory"
    static let liveDmInfo          = "\(BaseURL.live)/xlive/web-room/v1/index/getDanmuInfo"
    static let liveSendMsg         = "\(BaseURL.live)/msg/send"
    static let liveEmoticons       = "\(BaseURL.live)/xlive/web-ucenter/v2/emoticon/GetEmoticons"
    static let liveInfoByUser      = "\(BaseURL.live)/xlive/web-room/v1/index/getInfoByUser"
    static let liveUserSilent      = "\(BaseURL.live)/liveact/user_silent"
    static let liveAddShieldKeyword = "\(BaseURL.live)/xlive/web-ucenter/v1/banned/AddShieldKeyword"
    static let liveDelShieldKeyword = "\(BaseURL.live)/xlive/web-ucenter/v1/banned/DelShieldKeyword"
    static let liveShieldUser      = "\(BaseURL.live)/liveact/shield_user"
    static let liveFeed            = "\(BaseURL.live)/xlive/app-interface/v2/index/feed"
    static let liveFollowing       = "\(BaseURL.live)/xlive/web-ucenter/user/following"
    static let liveSecondList      = "\(BaseURL.live)/xlive/app-interface/v2/second/getList"
    static let liveAreaList        = "\(BaseURL.live)/xlive/app-interface/v2/index/getAreaList"
    static let liveRoomAreaList    = "\(BaseURL.live)/room/v1/Area/getList"
    static let liveFavTag          = "\(BaseURL.live)/xlive/app-interface/v2/second/get_fav_tag"
    static let liveSetFavTag       = "\(BaseURL.live)/xlive/app-interface/v2/second/set_fav_tag"
    static let liveSearch          = "\(BaseURL.live)/xlive/app-interface/v2/search_live"
    static let liveContributionRank = "\(BaseURL.live)/xlive/general-interface/v1/rank/queryContributionRank"
    static let liveLikeReport      = "\(BaseURL.live)/xlive/app-ucenter/v1/like_info_v3/like/likeReportV3"
    static let liveMedalWall       = "\(BaseURL.live)/xlive/app-ucenter/v1/guard/MainGuardCardAll"
    static let liveSuperChatList   = "\(BaseURL.live)/av/v1/SuperChat/getMessageList"
    static let liveSuperChatReport = "\(BaseURL.live)/av/v1/SuperChat/report"
    static let liveGuardInfo       = "\(BaseURL.live)/xlive/app-ucenter/v1/guard/MainGuardCardAll"

    // MARK: - 播放心跳
    static let heartbeat          = "/x/click-interface/web/heartbeat"
    static let historyReport      = "/x/v2/history/report"
    static let onlineTotal        = "/x/player/online/total"

    // MARK: - 视频截图
    static let videoShot          = "/x/player/videoshot"

    // MARK: - 笔记
    static let archiveNoteList    = "/x/note/publish/list/archive"
    static let noteList           = "/x/note/list"
    static let userNoteList       = "/x/note/publish/list/user"
    static let noteAdd            = "/x/note/add"
    static let noteDel            = "/x/note/del"
    static let notePublishDel     = "/x/note/publish/del"
    static let archiveNoteList2   = "/x/note/list/archive"

    // MARK: - 专栏
    static let articleViewinfo    = "/x/article/viewinfo"
    static let articleView        = "/x/article/view"
    static let articleListWeb     = "/x/article/list/web/articles"
    static let articleFavAdd      = "/x/article/favorites/add"
    static let articleFavDel      = "/x/article/favorites/del"
    static let articleCommunity   = "/x/community/cosmo/interface/simple_action"

    // MARK: - 分 P
    static let pageList           = "/x/player/pagelist"
    static let videoTags          = "/x/web-interface/view/detail/tag"

    // MARK: - 黑名单
    static let blackList          = "/x/relation/blacks"

    // MARK: - 登录
    static let captcha            = "/x/passport-login/captcha?source=main_web"
    static let webSmsCode         = "/x/passport-login/web/sms/send"
    static let webLogin           = "/x/passport-login/web/login"
    static let webLoginKey        = "/x/passport-login/web/key"
    static let appSmsCode         = "/x/passport-login/sms/send"
    static let appSmsLogin        = "/x/passport-login/login/sms"
    static let appPasswordLogin   = "/x/passport-login/oauth2/login"
    static let accessToken        = "/x/passport-login/oauth2/access_token"
    static let safeCenterUserInfo = "/x/safecenter/user/info"
    static let safeCaptchePre     = "/x/safecenter/captcha/pre"
    static let safeCenterSms      = "/x/safecenter/common/sms/send"
    static let safeCenterVerify   = "/x/safecenter/login/tel/verify"
    static let tvQrConfirm        = "/x/passport-tv-login/h5/qrcode/confirm"
    static let tvQrCode           = "/x/passport-tv-login/qrcode/auth_code"
    static let tvQrPoll           = "/x/passport-tv-login/qrcode/poll"
    static let logout             = "/login/exit/v2"

    // MARK: - 会员信息
    static let coinLog            = "/x/member/web/coin/log"
    static let loginLog           = "/x/member/web/login/log"
    static let expLog             = "/x/member/web/exp/log"
    static let moralLog           = "/x/member/web/moral/log"

    // MARK: - 弹幕
    static let danmakuPost        = "/x/v2/dm/post"
    static let danmakuFilter      = "/x/dm/filter/user"
    static let danmakuFilterAdd   = "/x/dm/filter/user/add"
    static let danmakuFilterDel   = "/x/dm/filter/user/del"
    static let danmakuLike        = "/x/v2/dm/thumbup/add"
    static let danmakuReport      = "/x/dm/report/add"
    static let danmakuRecall      = "/x/dm/recall"
    static let danmakuEditState   = "/x/v2/dm/edit/state"
    static let liveDanmakuReport  = "\(BaseURL.live)/xlive/web-ucenter/v1/dMReport/Report"

    // MARK: - 其他
    static let uploadImage        = "/x/upload/web/image"
    static let gaiaRegister       = "/x/gaia-vgate/v1/register"
    static let gaiaValidate       = "/x/gaia-vgate/v1/validate"
    static let voteInfo           = "/x/vote/vote_info"
    static let doVote             = "/x/vote/do_vote"
    static let voteCreate         = "/x/vote/create"
    static let voteUpdate         = "/x/vote/update"
    static let createReserve      = "/x/new-reserve/up/reserve/create"
    static let updateReserve      = "/x/new-reserve/up/reserve/update"
    static let reserveInfo        = "/x/new-reserve/up/reserve/info"
    static let loginDevices       = "/x/safecenter/user_login_devices"
    static let bgmDetail          = "/x/copyright-music-publicity/bgm/detail"
    static let bgmWishUpdate      = "/x/copyright-music-publicity/bgm/wish/update"
    static let bgmRcmd            = "/x/copyright-music-publicity/bgm/recommend_list"
    static let matchInfo          = "/x/esports/match/info"
    static let dynPic             = "/x/polymer/web-dynamic/v1/detail/pic"
    static let ranking            = "/x/web-interface/ranking/v2"
    static let popularSeriesOne   = "/x/web-interface/popular/series/one"
    static let popularSeriesList  = "/x/web-interface/popular/series/list"
    static let popularPrecious    = "/x/web-interface/popular/precious"
    static let aiConclusion       = "/x/web-interface/view/conclusion/get"
    static let reportMember       = "/ajax/report/add"
    static let upowerRank         = "/x/upower/up/member/rank/v2"
    static let coinArticle        = "/x/space/coin/article"
    static let spaceShop          = "/community-hub/small_shop/feed/tab/item"
    static let archiveRelation    = "/x/web-interface/archive/relation"
    static let activateBuvid      = "/x/internal/gaia-gateway/ExClimbWuzhi"
    static let membersShop        = "/xlive/web-ucenter/user/MedalWall"

    // MARK: - SponsorBlock
    static let sponsorBlockQuery  = "\(BaseURL.sponsorBlock)/api/skipSegments"
    static let sponsorBlockVote   = "\(BaseURL.sponsorBlock)/api/voteOnSponsorTime"

    // MARK: - ViewModel 兼容别名（统一命名空间）
    static let recommend          = recommendListWeb
    static let popularFeed        = hotList
    static let videoInfo          = videoIntro
    static let videoPlayUrl       = ugcUrl
    static let videoRelated       = relatedVideos
    static let videoLikeStatus    = videoRelation
    static let videoFavStatus     = "/x/v2/fav/video/favoured"
    static let videoLike          = "/x/web-interface/archive/like"
    static let searchHot          = searchHotWord
    static let pgcInfo            = pgcSeasonInfo
    static let msgSession         = sessionList
    static let msgFetchSession    = sessionMessages
    static let msgSend            = sendMsg
    static let msgReplyMe         = msgFeedReply
    static let msgAt              = msgFeedAt
    static let msgLike            = msgFeedLike
    static let msgSys             = sysNotifyList
    static let memberVideo        = spaceArcSearch
    static let loginQRGenerate    = tvQrCode
    static let loginQRPoll        = tvQrPoll
    static let ranklist           = ranking
    static let liveRecommend      = liveUserRcmd
    static let liveGetList        = liveSecondList
    static let liveRoomInfo       = liveRoomInfoH5
    static let popularRank        = ranking
    static let followers          = fans
    static let dynamicFeed        = dynFeedAll
    static let dynamicDetail      = dynDetail
    static let favFolderList      = favFolderListAll
    static let favDetail          = favResourceList
    static let myInfo             = userInfo
}

// MARK: - 全局别名（解决 ViewModel 中 APIEndpoints.xxx 引用）
typealias APIEndpoints = Endpoints
