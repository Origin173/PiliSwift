import SwiftUI

/// 根视图 — 对应 Flutter 的 MainApp (lib/pages/main/view.dart)
/// 使用 TabView 承载四个主 Tab + NavigationStack
struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router

    @State private var selectedTab: TabItem = .home

    var body: some View {
        @Bindable var router = router

        TabView(selection: $selectedTab) {
            // 首页 Tab
            NavigationStack(path: $router.homePath) {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        RouteDestinationView(route: route)
                    }
            }
            .tabItem { Label("首页", systemImage: "house.fill") }
            .tag(TabItem.home)

            // 热门 Tab
            NavigationStack(path: $router.hotPath) {
                HotView()
                    .navigationDestination(for: Route.self) { route in
                        RouteDestinationView(route: route)
                    }
            }
            .tabItem { Label("热门", systemImage: "flame.fill") }
            .tag(TabItem.hot)

            // 动态 Tab
            NavigationStack(path: $router.dynamicsPath) {
                DynamicsView()
                    .navigationDestination(for: Route.self) { route in
                        RouteDestinationView(route: route)
                    }
            }
            .tabItem { Label("动态", systemImage: "bell.fill") }
            .tag(TabItem.dynamics)

            // 我的 Tab
            NavigationStack(path: $router.minePath) {
                MineView()
                    .navigationDestination(for: Route.self) { route in
                        RouteDestinationView(route: route)
                    }
            }
            .tabItem { Label("我的", systemImage: "person.fill") }
            .tag(TabItem.mine)
        }
        .tint(.accentColor)
    }
}

// MARK: - Tab 枚举
enum TabItem: Hashable {
    case home
    case hot
    case dynamics
    case mine
}

// MARK: - 路由目标视图分发器
/// 根据 Route 枚举分发到对应的 View
struct RouteDestinationView: View {
    let route: Route

    var body: some View {
        switch route {
        // 视频
        case .videoDetail(let params):
            VideoDetailView(params: params)

        // 用户空间
        case .member(let mid):
            MemberView(mid: mid)

        case .memberHome(let mid):
            MemberHomeView(mid: mid)

        case .memberDynamics(let mid):
            MemberDynamicsView(mid: mid)

        case .memberVideo(let mid):
            MemberVideoView(mid: mid)

        case .memberProfile:
            MemberProfileView()

        // 搜索
        case .search:
            SearchView()

        case .searchResult(let keyword):
            SearchResultView(keyword: keyword)

        case .searchTrending:
            SearchTrendingView()

        // 动态
        case .dynamicDetail(let id):
            DynamicDetailView(id: id)

        case .dynamicsTopic(let topicName):
            DynamicsTopicView(topicName: topicName)

        // 收藏
        case .fav(let mid):
            FavView(mid: mid)

        case .favDetail(let id, let title):
            FavDetailView(mediaId: id, title: title)

        // 历史
        case .history:
            HistoryView()

        // 稍后再看
        case .later:
            LaterView()

        // 以下 Tab 页也可以被 push
        case .hot:
            HotView()

        case .rank:
            RankView()

        // 直播
        case .liveRoom(let roomId):
            LiveRoomView(roomId: roomId)

        case .liveArea:
            LiveAreaView()

        case .live:
            LiveView()

        // 关注 & 粉丝
        case .follow(let mid):
            FollowView(mid: mid)

        case .fan(let mid):
            FanView(mid: mid)

        // 消息
        case .whisper:
            WhisperView()

        case .whisperDetail(let talkerId):
            WhisperDetailView(talkerId: talkerId)

        case .replyMe:
            ReplyMeView()

        case .atMe:
            AtMeView()

        case .likeMe:
            LikeMeView()

        case .sysMsg:
            SysMsgView()

        // 番剧/PGC
        case .pgc(let seasonId):
            PGCView(seasonId: seasonId)

        case .pgcIndex:
            PGCIndexView()

        case .subscription:
            SubscriptionView()

        // 设置
        case .setting:
            SettingView()

        case .recommendSetting:
            RecommendSettingView()

        case .videoSetting:
            VideoSettingView()

        case .playSetting:
            PlaySettingView()

        case .styleSetting:
            StyleSettingView()

        case .privacySetting:
            PrivacySettingView()

        case .extraSetting:
            ExtraSettingView()

        case .colorSetting:
            ColorSettingView()

        case .fontSizeSetting:
            FontSizeSettingView()

        case .barSetting:
            BarSettingView()

        case .settingsSearch:
            SettingsSearchView()

        // 其他
        case .login:
            LoginView()

        case .about:
            AboutView()

        case .article(let id):
            ArticleView(id: id)

        case .download:
            DownloadView()

        case .webview(let url):
            WebViewPage(url: url)

        case .blacklist:
            BlacklistView()

        case .danmakuBlock:
            DanmakuBlockView()

        case .sponsorBlock:
            SponsorBlockView()

        case .audio(let id):
            AudioView(id: id)

        case .music:
            MusicView()

        case .dlna:
            DLNAView()

        case .webdav:
            WebDavView()

        case .matchInfo(let matchId):
            MatchInfoView(matchId: matchId)

        case .popularSeries:
            PopularSeriesView()

        case .popularPrecious:
            PopularPreciousView()

        case .loginDevices:
            LoginDevicesView()

        case .logs:
            LogsView()

        case .myReply:
            MyReplyView()

        case .mainReply(let params):
            MainReplyView(params: params)

        case .pgcReview(let seasonId):
            PGCReviewView(seasonId: seasonId)

        case .subscription_detail(let seasonId):
            SubscriptionDetailView(seasonId: seasonId)

        case .articleList(let mid):
            ArticleListView(mid: mid)

        case .memberSearch(let mid):
            MemberSearchView(mid: mid)

        case .followSearch(let mid):
            FollowSearchView(mid: mid)

        case .spaceSetting:
            SpaceSettingView()

        case .upowerRank(let mid):
            UpowerRankView(mid: mid)

        case .dynTopicRcmd:
            DynTopicRcmdView()

        // MARK: - 成员子页（不常用，占位）
        case .memberAudio(let mid):
            MemberAudioView(mid: mid)
        case .memberArticle(let mid):
            MemberArticleView(mid: mid)
        case .memberOpus(let mid):
            MemberOpusView(mid: mid)
        case .memberPgc(let mid):
            MemberPGCView(mid: mid)
        case .memberSeason(let mid):
            MemberSeasonView(mid: mid)
        case .memberGuard(let mid):
            MemberGuardView(mid: mid)
        case .memberShop(let mid):
            MemberShopView(mid: mid)
        case .memberFavorite(let mid):
            MemberFavoriteView(mid: mid)
        case .memberCheese(let mid):
            MemberCheeseView(mid: mid)
        case .memberComic(let mid):
            MemberComicView(mid: mid)
        case .memberUpowerRank(let mid):
            UpowerRankView(mid: mid)
        case .memberContribute(let mid):
            MemberContributeView(mid: mid)

        // MARK: - 直播分区详情
        case .liveAreaDetail(let parentId, let areaName):
            LiveAreaDetailView(parentId: parentId, areaName: areaName)

        // MARK: - 被关注 / 共同关注
        case .followed(let mid):
            FollowView(mid: mid)
        case .sameFollowing(let mid):
            FollowView(mid: mid)
        }
    }
}
