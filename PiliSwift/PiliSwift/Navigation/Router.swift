import SwiftUI
import Observation

// MARK: - 路由管理器
// 映射自 lib/router/app_pages.dart 的 GetX Named Route 系统
// 使用 iOS 16+ NavigationStack + NavigationPath

@Observable
final class Router {
    // 每个主 Tab 独立的导航栈
    var homePath      = NavigationPath()
    var hotPath       = NavigationPath()
    var dynamicsPath  = NavigationPath()
    var minePath      = NavigationPath()

    // 当前激活 Tab（用于 deep link 跳转到正确 Tab）
    var activeTab: TabItem = .home

    // Sheet 和 FullScreenCover 展示
    var presentedSheet: Route? = nil
    var presentedFullScreen: Route? = nil

    // MARK: - 导航操作

    /// Push 路由到当前激活 Tab 的导航栈
    func push(_ route: Route) {
        switch activeTab {
        case .home:      homePath.append(route)
        case .hot:       hotPath.append(route)
        case .dynamics:  dynamicsPath.append(route)
        case .mine:      minePath.append(route)
        }
    }

    /// Push 到指定 Tab 的导航栈（可能需要切换 Tab）
    func push(_ route: Route, in tab: TabItem) {
        switch tab {
        case .home:      homePath.append(route)
        case .hot:       hotPath.append(route)
        case .dynamics:  dynamicsPath.append(route)
        case .mine:      minePath.append(route)
        }
    }

    /// 弹出当前 Tab 最顶部路由
    func pop() {
        switch activeTab {
        case .home:      if !homePath.isEmpty { homePath.removeLast() }
        case .hot:       if !hotPath.isEmpty { hotPath.removeLast() }
        case .dynamics:  if !dynamicsPath.isEmpty { dynamicsPath.removeLast() }
        case .mine:      if !minePath.isEmpty { minePath.removeLast() }
        }
    }

    /// 弹出当前 Tab 所有路由（回到根页面）
    func popToRoot() {
        switch activeTab {
        case .home:      homePath.removeLast(homePath.count)
        case .hot:       hotPath.removeLast(hotPath.count)
        case .dynamics:  dynamicsPath.removeLast(dynamicsPath.count)
        case .mine:      minePath.removeLast(minePath.count)
        }
    }

    /// 以 Sheet 方式展示
    func present(_ route: Route) {
        presentedSheet = route
    }

    /// 以全屏 Cover 方式展示
    func presentFullScreen(_ route: Route) {
        presentedFullScreen = route
    }

    func dismiss() {
        presentedSheet = nil
        presentedFullScreen = nil
    }

    // MARK: - Deep Link 处理

    func handleDeepLink(_ url: URL) {
        guard let route = DeepLink.parse(url) else { return }
        // 视频/直播等深链接直接 push 到首页 Tab
        push(route, in: .home)
        activeTab = .home
    }
}
