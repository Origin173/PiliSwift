import SwiftUI

/// 个人中心页
/// 对应 Flutter: lib/pages/mine/view.dart
struct MineView: View {
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MineLoggedInView()
            } else {
                MineGuestView()
            }
        }
        .navigationTitle("我的")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 已登录
private struct MineLoggedInView: View {
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router

    var body: some View {
        List {
            // 头部用户信息
            Section {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: appState.faceURL)) { img in
                        img.resizable()
                    } placeholder: {
                        Circle().fill(.fill.secondary)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.username)
                            .font(.title3.bold())
                        Text("UID: \(appState.uid)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    NavigationLink(value: Route.memberProfile) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            // 快捷功能
            Section("内容") {
                NavigationLink(value: Route.history) {
                    Label("历史记录", systemImage: "clock")
                }
                NavigationLink(value: Route.later) {
                    Label("稍后再看", systemImage: "bookmark")
                }
                NavigationLink(value: Route.fav(mid: appState.uid)) {
                    Label("收藏", systemImage: "star")
                }
                NavigationLink(value: Route.subscription) {
                    Label("我的追番", systemImage: "tv")
                }
                NavigationLink(value: Route.download) {
                    Label("离线缓存", systemImage: "arrow.down.circle")
                }
            }

            Section("互动") {
                NavigationLink(value: Route.follow(mid: appState.uid)) {
                    Label("关注", systemImage: "person.badge.plus")
                }
                NavigationLink(value: Route.whisper) {
                    Label("私信", systemImage: "message")
                }
            }

            Section("其他") {
                NavigationLink(value: Route.setting) {
                    Label("设置", systemImage: "gear")
                }
                NavigationLink(value: Route.about) {
                    Label("关于", systemImage: "info.circle")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - 未登录
private struct MineGuestView: View {
    @Environment(Router.self) private var router

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.circle")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)

            Text("登录后查看个人内容")
                .font(.headline)
                .foregroundStyle(.secondary)

            Button("立即登录") {
                router.push(.login)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
