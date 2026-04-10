import SwiftUI

// MARK: - 设置主页
/// 对应 Flutter: lib/pages/setting/view.dart
struct SettingView: View {
    @Environment(Router.self) private var router

    var body: some View {
        List {
            Section("推荐与内容") {
                NavigationLink(value: Route.recommendSetting) { Label("推荐设置", systemImage: "wand.and.stars") }
                NavigationLink(value: Route.settingsSearch)   { Label("设置搜索", systemImage: "magnifyingglass") }
            }
            Section("视频与播放") {
                NavigationLink(value: Route.videoSetting) { Label("视频设置", systemImage: "video") }
                NavigationLink(value: Route.playSetting)  { Label("播放设置", systemImage: "play.circle") }
            }
            Section("外观") {
                NavigationLink(value: Route.styleSetting)    { Label("界面风格", systemImage: "paintbrush") }
                NavigationLink(value: Route.colorSetting)    { Label("主题色", systemImage: "eyedropper") }
                NavigationLink(value: Route.fontSizeSetting) { Label("字体大小", systemImage: "textformat.size") }
                NavigationLink(value: Route.barSetting)      { Label("标签栏", systemImage: "square.grid.2x2") }
            }
            Section("隐私与安全") {
                NavigationLink(value: Route.privacySetting) { Label("隐私设置", systemImage: "hand.raised") }
                NavigationLink(value: Route.blacklist)      { Label("黑名单", systemImage: "person.fill.xmark") }
                NavigationLink(value: Route.loginDevices)   { Label("登录设备", systemImage: "iphone.and.arrow.forward") }
            }
            Section("弹幕") {
                NavigationLink(value: Route.danmakuBlock)  { Label("弹幕过滤", systemImage: "text.bubble") }
                NavigationLink(value: Route.sponsorBlock)  { Label("SponsorBlock", systemImage: "scissors") }
            }
            Section("其他") {
                NavigationLink(value: Route.extraSetting) { Label("其他设置", systemImage: "ellipsis.circle") }
                NavigationLink(value: Route.spaceSetting)  { Label("本地存储", systemImage: "internaldrive") }
                NavigationLink(value: Route.webdav)        { Label("WebDAV", systemImage: "server.rack") }
                NavigationLink(value: Route.dlna)          { Label("DLNA 投屏", systemImage: "airplayvideo") }
                NavigationLink(value: Route.logs)          { Label("应用日志", systemImage: "doc.text.magnifyingglass") }
                NavigationLink(value: Route.about)         { Label("关于", systemImage: "info.circle") }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 推荐设置
struct RecommendSettingView: View {
    @AppStorage("enablePrivacyMode") private var enablePrivacyMode = false
    @AppStorage("feedSource") private var feedSource = 0

    var body: some View {
        Form {
            Section {
                Toggle("隐私模式（不刷新推荐）", isOn: $enablePrivacyMode)
                Picker("推荐来源", selection: $feedSource) {
                    Text("个性推荐").tag(0)
                    Text("热门推荐").tag(1)
                }
            }
        }
        .navigationTitle("推荐设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 视频设置
struct VideoSettingView: View {
    @AppStorage("defaultVideoQuality") private var defaultQuality = 80

    var body: some View {
        Form {
            Section("默认画质") {
                Picker("画质", selection: $defaultQuality) {
                    Text("4K (2160P)").tag(120)
                    Text("1080P 60帧").tag(116)
                    Text("1080P+").tag(112)
                    Text("1080P").tag(80)
                    Text("720P 60帧").tag(74)
                    Text("720P").tag(64)
                    Text("480P").tag(32)
                    Text("360P").tag(16)
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle("视频设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 播放设置
struct PlaySettingView: View {
    @AppStorage("autoPlayNext") private var autoPlayNext = true
    @AppStorage("defaultSpeed") private var defaultSpeed = 1.0

    var body: some View {
        Form {
            Section {
                Toggle("自动播放下一集", isOn: $autoPlayNext)
                Picker("默认倍速", selection: $defaultSpeed) {
                    Text("0.5x").tag(0.5)
                    Text("0.75x").tag(0.75)
                    Text("1.0x").tag(1.0)
                    Text("1.25x").tag(1.25)
                    Text("1.5x").tag(1.5)
                    Text("2.0x").tag(2.0)
                }
            }
        }
        .navigationTitle("播放设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 界面风格
struct StyleSettingView: View {
    @AppStorage("preferredColorScheme") private var scheme = 0

    var body: some View {
        Form {
            Picker("主题模式", selection: $scheme) {
                Text("跟随系统").tag(0)
                Text("浅色").tag(1)
                Text("深色").tag(2)
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("界面风格")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 主题色
struct ColorSettingView: View {
    var body: some View {
        Form {
            Text("主题色自定义（TODO）")
        }
        .navigationTitle("主题色")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 字体大小
struct FontSizeSettingView: View {
    @AppStorage("fontSizeScale") private var scale = 1.0

    var body: some View {
        Form {
            Slider(value: $scale, in: 0.8...1.4, step: 0.1) {
                Text("字体大小")
            } minimumValueLabel: {
                Text("小")
            } maximumValueLabel: {
                Text("大")
            }
            Text("预览文字大小").font(.system(size: 15 * scale))
        }
        .navigationTitle("字体大小")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 标签栏设置
struct BarSettingView: View {
    var body: some View {
        Form { Text("标签栏自定义（TODO）") }
            .navigationTitle("标签栏设置")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 隐私设置
struct PrivacySettingView: View {
    @AppStorage("disableRecommendHistory") private var disableRecommendHistory = false

    var body: some View {
        Form {
            Toggle("不使用历史记录优化推荐", isOn: $disableRecommendHistory)
        }
        .navigationTitle("隐私设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 其他设置
struct ExtraSettingView: View {
    var body: some View {
        Form { Text("其他设置项（TODO）") }
            .navigationTitle("其他设置")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 设置搜索
struct SettingsSearchView: View {
    @State private var query = ""
    var body: some View {
        List {
            Text("搜索设置项")
        }
        .searchable(text: $query, prompt: "搜索设置")
        .navigationTitle("设置搜索")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 本地存储
struct SpaceSettingView: View {
    var body: some View {
        Form {
            Section("缓存") {
                Button("清空视频缓存", role: .destructive) { }
                Button("清空图片缓存", role: .destructive) { }
            }
        }
        .navigationTitle("本地存储")
        .navigationBarTitleDisplayMode(.inline)
    }
}
