import SwiftUI
import WebKit

// MARK: - 登录页
/// 对应 Flutter: lib/pages/login/view.dart
struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Logo
                Image(systemName: "play.tv")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.accentColor)

                Text("登录到 Bilibili")
                    .font(.title2.bold())

                // 二维码区域
                if let qrImage = viewModel.qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                } else if viewModel.isLoadingQR {
                    ProgressView()
                        .frame(width: 200, height: 200)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.fill.secondary)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Button("获取二维码") {
                                Task { await viewModel.fetchQRCode() }
                            }
                        )
                }

                Text("使用哔哩哔哩 App 扫描二维码登录")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("刷新二维码") {
                    Task { await viewModel.fetchQRCode() }
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .navigationTitle("登录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
            }
        }
        .task { await viewModel.fetchQRCode() }
        .onChange(of: viewModel.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                Task {
                    await appState.refreshUserInfo()
                    dismiss()
                }
            }
        }
    }
}

// MARK: - 关于页
struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "play.tv.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.accentColor)
                        Text("PiliSwift")
                            .font(.title2.bold())
                        Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)

            Section("项目") {
                Link(destination: URL(string: "https://github.com/guozhigq/pilipala")!) {
                    Label("原 Flutter 项目 (PiliPlus)", systemImage: "link")
                }
                Label("SwiftUI 重写", systemImage: "swift")
            }

            Section("开源协议") {
                Label("MIT License", systemImage: "doc.text")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 文章详情
struct ArticleView: View {
    let id: Int64
    var body: some View {
        Text("专栏文章 (\(id))")
            .navigationTitle("文章")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 专栏列表
struct ArticleListView: View {
    let mid: Int64
    var body: some View {
        Text("UP主专栏 (\(mid))")
            .navigationTitle("专栏")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 离线下载
struct DownloadView: View {
    var body: some View {
        Text("离线缓存管理（TODO）")
            .navigationTitle("离线缓存")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - WebView 页
struct WebViewPage: View {
    let url: URL

    var body: some View {
        WebViewRepresentable(url: url)
            .navigationTitle(url.host() ?? "网页")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Link(destination: url) {
                        Image(systemName: "safari")
                    }
                }
            }
    }
}

private struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

// MARK: - 黑名单
struct BlacklistView: View {
    var body: some View {
        Text("黑名单管理（TODO）")
            .navigationTitle("黑名单")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 弹幕过滤
struct DanmakuBlockView: View {
    var body: some View {
        Form {
            Text("弹幕关键词过滤（TODO）")
        }
        .navigationTitle("弹幕过滤")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - SponsorBlock
struct SponsorBlockView: View {
    @AppStorage("sponsorBlockEnabled") private var enabled = true

    var body: some View {
        Form {
            Toggle("启用 SponsorBlock", isOn: $enabled)
        }
        .navigationTitle("SponsorBlock")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 音频详情
struct AudioView: View {
    let id: Int64
    var body: some View {
        Text("音频 (\(id))")
            .navigationTitle("音频")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 音乐播放器
struct MusicView: View {
    var body: some View {
        Text("音乐播放器（TODO）")
            .navigationTitle("音乐")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - DLNA 投屏
struct DLNAView: View {
    var body: some View {
        Text("DLNA 投屏（TODO）")
            .navigationTitle("DLNA 投屏")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - WebDAV
struct WebDavView: View {
    var body: some View {
        Form {
            Section("WebDAV 服务器") {
                TextField("URL", text: .constant(""))
                    .keyboardType(.URL)
                TextField("用户名", text: .constant(""))
                SecureField("密码", text: .constant(""))
            }
        }
        .navigationTitle("WebDAV")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 赛事信息
struct MatchInfoView: View {
    let matchId: String
    var body: some View {
        Text("赛事详情 (\(matchId))")
            .navigationTitle("赛事")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 精彩看点（热门系列）
struct PopularSeriesView: View {
    var body: some View {
        Text("热门系列（TODO）")
            .navigationTitle("热门系列")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 入站必刷
struct PopularPreciousView: View {
    var body: some View {
        Text("入站必刷（TODO）")
            .navigationTitle("入站必刷")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 登录设备管理
struct LoginDevicesView: View {
    var body: some View {
        Text("登录设备管理（TODO）")
            .navigationTitle("登录设备")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 日志
struct LogsView: View {
    var body: some View {
        Text("应用日志（TODO）")
            .navigationTitle("日志")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 成员子页占位
struct MemberAudioView: View {
    let mid: Int64
    var body: some View { Text("音频投稿 (\(mid))").navigationTitle("音频") }
}
struct MemberArticleView: View {
    let mid: Int64
    var body: some View { Text("专栏 (\(mid))").navigationTitle("专栏") }
}
struct MemberOpusView: View {
    let mid: Int64
    var body: some View { Text("图文动态 (\(mid))").navigationTitle("图文") }
}
struct MemberPGCView: View {
    let mid: Int64
    var body: some View { Text("番剧出演 (\(mid))").navigationTitle("番剧出演") }
}
struct MemberSeasonView: View {
    let mid: Int64
    var body: some View { Text("合集 (\(mid))").navigationTitle("合集") }
}
struct MemberGuardView: View {
    let mid: Int64
    var body: some View { Text("大航海 (\(mid))").navigationTitle("大航海") }
}
struct MemberShopView: View {
    let mid: Int64
    var body: some View { Text("周边 (\(mid))").navigationTitle("周边") }
}
struct MemberFavoriteView: View {
    let mid: Int64
    var body: some View { Text("收藏夹 (\(mid))").navigationTitle("收藏夹") }
}
struct MemberCheeseView: View {
    let mid: Int64
    var body: some View { Text("课程 (\(mid))").navigationTitle("课程") }
}
struct MemberComicView: View {
    let mid: Int64
    var body: some View { Text("漫画 (\(mid))").navigationTitle("漫画") }
}
struct MemberContributeView: View {
    let mid: Int64
    var body: some View { Text("合集投稿 (\(mid))").navigationTitle("合集投稿") }
}
struct LiveAreaDetailView: View {
    let parentId: Int64
    let areaName: String
    var body: some View { Text("直播分区: \(areaName)").navigationTitle(areaName) }
}
