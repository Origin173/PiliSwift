import Foundation

// MARK: - 请求头常量
// 映射自 lib/common/constants.dart 和 lib/http/init.dart

struct RequestHeaders {
    // MARK: - 静态常量
    static let appKey   = "dfca71928277209b"
    static let appSec   = "b5475a8825547a4fc26c7d518eaaa02e"
    static let traceId  = "11111111111111111111111111111111:1111111111111111:0:0"

    /// Web 端 User-Agent
    static let userAgent = "Mozilla/5.0 BiliDroid/2.0.1 (bbcallen@gmail.com) os/android model/android_hd mobi_app/android_hd build/2001100 channel/master innerVer/2001100 osVer/15 network/2"

    /// App 端 User-Agent
    static let userAgentApp = "Mozilla/5.0 BiliDroid/8.43.0 (bbcallen@gmail.com) os/android model/android mobi_app/android build/8430300 channel/master innerVer/8430300 osVer/15 network/2"

    /// App 端统计信息
    static let statistics    = #"{"appId":5,"platform":3,"version":"2.0.1","abtest":""}"#
    static let statisticsApp = #"{"appId":1,"platform":3,"version":"8.43.0","abtest":""}"#

    /// 基础请求头 (向 API 请求时附加)
    static let baseHeaders: [String: String] = [
        "env":                 "prod",
        "app-key":             "android64",
        "x-bili-aurora-zone":  "sh001",
    ]

    /// 构建完整请求头（合并 base + Cookie + 自定义）
    static func build(
        extra: [String: String] = [:],
        useAppUA: Bool = false
    ) -> [String: String] {
        var headers = baseHeaders
        headers["user-agent"] = useAppUA ? userAgentApp : userAgent
        headers["accept-encoding"] = "gzip"
        headers.merge(extra) { _, new in new }
        // 附加已登录 Cookie
        if let cookie = AccountStorage.shared.cookieString {
            headers["Cookie"] = cookie
        }
        return headers
    }
}
