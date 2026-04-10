import Foundation

// MARK: - 本地偏好存储
// 映射自 lib/utils/storage_pref.dart (Pref 类) 和 lib/utils/storage_key.dart
// 使用 UserDefaults + @AppStorage 友好的静态属性

final class Preferences {
    static let shared = Preferences()

    private let defaults = UserDefaults.standard

    private init() {}

    func setup() {
        CookieManager.shared.restore()
    }

    // MARK: - 账号相关
    var defaultAccountUid: String {
        get { defaults.string(forKey: Keys.defaultAccountUid) ?? "" }
        set { defaults.set(newValue, forKey: Keys.defaultAccountUid) }
    }

    // MARK: - 视频播放
    var defaultVideoQuality: Int {
        get { defaults.integer(forKey: Keys.defaultVideoQuality).nonZeroOr(64) }
        set { defaults.set(newValue, forKey: Keys.defaultVideoQuality) }
    }

    var defaultAudioQuality: Int {
        get { defaults.integer(forKey: Keys.defaultAudioQuality).nonZeroOr(30280) }
        set { defaults.set(newValue, forKey: Keys.defaultAudioQuality) }
    }

    var enableDanmaku: Bool {
        get { defaults.bool(forKey: Keys.enableDanmaku, defaultValue: true) }
        set { defaults.set(newValue, forKey: Keys.enableDanmaku) }
    }

    var danmakuOpacity: Double {
        get { defaults.double(forKey: Keys.danmakuOpacity).zeroOr(1.0) }
        set { defaults.set(newValue, forKey: Keys.danmakuOpacity) }
    }

    var danmakuFontSize: Double {
        get { defaults.double(forKey: Keys.danmakuFontSize).zeroOr(15.0) }
        set { defaults.set(newValue, forKey: Keys.danmakuFontSize) }
    }

    var danmakuSpeed: Double {
        get { defaults.double(forKey: Keys.danmakuSpeed).zeroOr(8.0) }
        set { defaults.set(newValue, forKey: Keys.danmakuSpeed) }
    }

    var enableHardwareDecode: Bool {
        get { defaults.bool(forKey: Keys.enableHardwareDecode, defaultValue: true) }
        set { defaults.set(newValue, forKey: Keys.enableHardwareDecode) }
    }

    var defaultPlaybackSpeed: Double {
        get { defaults.double(forKey: Keys.defaultPlaybackSpeed).zeroOr(1.0) }
        set { defaults.set(newValue, forKey: Keys.defaultPlaybackSpeed) }
    }

    var enableAutoPlay: Bool {
        get { defaults.bool(forKey: Keys.enableAutoPlay, defaultValue: true) }
        set { defaults.set(newValue, forKey: Keys.enableAutoPlay) }
    }

    var enableBackgroundAudio: Bool {
        get { defaults.bool(forKey: Keys.enableBackgroundAudio, defaultValue: true) }
        set { defaults.set(newValue, forKey: Keys.enableBackgroundAudio) }
    }

    // MARK: - 主题
    var themeColorValue: Int {
        get { defaults.integer(forKey: Keys.themeColorValue) }
        set { defaults.set(newValue, forKey: Keys.themeColorValue) }
    }

    var appearanceMode: Int {
        get { defaults.integer(forKey: Keys.appearanceMode) }
        set { defaults.set(newValue, forKey: Keys.appearanceMode) }
    }

    var fontSize: Double {
        get { defaults.double(forKey: Keys.fontSize).zeroOr(14.0) }
        set { defaults.set(newValue, forKey: Keys.fontSize) }
    }

    // MARK: - 推荐设置
    var feedSource: Int {
        get { defaults.integer(forKey: Keys.feedSource) }
        set { defaults.set(newValue, forKey: Keys.feedSource) }
    }

    var enableRecommendFilter: Bool {
        get { defaults.bool(forKey: Keys.enableRecommendFilter, defaultValue: false) }
        set { defaults.set(newValue, forKey: Keys.enableRecommendFilter) }
    }

    // MARK: - 隐私
    var pauseHistory: Bool {
        get { defaults.bool(forKey: Keys.pauseHistory, defaultValue: false) }
        set { defaults.set(newValue, forKey: Keys.pauseHistory) }
    }

    // MARK: - 网络
    var enableSystemProxy: Bool {
        get { defaults.bool(forKey: Keys.enableSystemProxy, defaultValue: false) }
        set { defaults.set(newValue, forKey: Keys.enableSystemProxy) }
    }

    var systemProxyHost: String {
        get { defaults.string(forKey: Keys.systemProxyHost) ?? "" }
        set { defaults.set(newValue, forKey: Keys.systemProxyHost) }
    }

    var systemProxyPort: String {
        get { defaults.string(forKey: Keys.systemProxyPort) ?? "" }
        set { defaults.set(newValue, forKey: Keys.systemProxyPort) }
    }

    // MARK: - 杂项
    var downloadPath: String? {
        get { defaults.string(forKey: Keys.downloadPath) }
        set { defaults.set(newValue, forKey: Keys.downloadPath) }
    }

    var retryCount: Int {
        get { defaults.integer(forKey: Keys.retryCount).nonZeroOr(2) }
        set { defaults.set(newValue, forKey: Keys.retryCount) }
    }

    // MARK: - 键名常量（对应 lib/utils/storage_key.dart）
    enum Keys {
        static let defaultAccountUid    = "defaultAccountUid"
        static let defaultVideoQuality  = "defaultVideoQuality"
        static let defaultAudioQuality  = "defaultAudioQuality"
        static let enableDanmaku        = "enableDanmaku"
        static let danmakuOpacity       = "danmakuOpacity"
        static let danmakuFontSize      = "danmakuFontSize"
        static let danmakuSpeed         = "danmakuSpeed"
        static let enableHardwareDecode = "enableHardwareDecode"
        static let defaultPlaybackSpeed = "defaultPlaybackSpeed"
        static let enableAutoPlay       = "enableAutoPlay"
        static let enableBackgroundAudio = "enableBackgroundAudio"
        static let themeColorValue      = "themeColorValue"
        static let appearanceMode       = "appearanceMode"
        static let fontSize             = "fontSize"
        static let feedSource           = "feedSource"
        static let enableRecommendFilter = "enableRecommendFilter"
        static let pauseHistory         = "pauseHistory"
        static let enableSystemProxy    = "enableSystemProxy"
        static let systemProxyHost      = "systemProxyHost"
        static let systemProxyPort      = "systemProxyPort"
        static let downloadPath         = "downloadPath"
        static let retryCount           = "retryCount"
        static let wbiMixinKey          = "wbi_mixin_key"
        static let wbiCachedDay         = "wbi_cached_day"
    }
}

// MARK: - UserDefaults 扩展

private extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil { return defaultValue }
        return bool(forKey: key)
    }
}

private extension Int {
    func nonZeroOr(_ fallback: Int) -> Int { self == 0 ? fallback : self }
}

private extension Double {
    func zeroOr(_ fallback: Double) -> Double { self == 0 ? fallback : self }
}
