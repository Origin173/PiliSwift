import Foundation

// MARK: - Cookie 管理器
// 映射自 lib/http/init.dart 的 cookie_jar 逻辑

final class CookieManager {
    static let shared = CookieManager()

    private let storage = HTTPCookieStorage.shared
    private let cookieKey = "pili_cookies"

    private init() {}

    // MARK: - 持久化 Cookie 到 HTTPCookieStorage

    /// 从持久化存储恢复 Cookie
    func restore() {
        guard let data = UserDefaults.standard.data(forKey: cookieKey),
              let cookieArray = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSDictionary.self, NSString.self, NSNumber.self, NSDate.self, NSURL.self],
                from: data
              ) as? [[HTTPCookiePropertyKey: Any]] else { return }

        for props in cookieArray {
            if let cookie = HTTPCookie(properties: props) {
                storage.setCookie(cookie)
            }
        }
    }

    /// 持久化当前 Cookie
    func persist() {
        guard let cookies = storage.cookies else { return }
        let propsArray = cookies.compactMap { $0.properties }.map { props -> [HTTPCookiePropertyKey: Any] in
            // NSHTTPCookiePropertyKey 转 HTTPCookiePropertyKey
            var dict: [HTTPCookiePropertyKey: Any] = [:]
            for (k, v) in props { dict[k] = v }
            return dict
        }
        if let data = try? NSKeyedArchiver.archivedData(
            withRootObject: propsArray, requiringSecureCoding: false
        ) {
            UserDefaults.standard.set(data, forKey: cookieKey)
        }
    }

    /// 为指定 URL 获取 Cookie 字符串（格式：key=value; key2=value2）
    func cookieString(for url: URL) -> String {
        let cookies = storage.cookies(for: url) ?? []
        return cookies.map { "\($0.name)=\($0.value)" }.joined(separator: "; ")
    }

    /// 手动设置 Cookie（从服务器 Set-Cookie 响应头更新）
    func setCookies(_ cookies: [HTTPCookie], for url: URL) {
        for cookie in cookies {
            storage.setCookie(cookie)
        }
        persist()
    }

    /// 清除所有 Cookie
    func clearAll() {
        storage.cookies?.forEach { storage.deleteCookie($0) }
        UserDefaults.standard.removeObject(forKey: cookieKey)
    }

    /// 判断是否有登录态（存在 SESSDATA Cookie）
    var hasSession: Bool {
        storage.cookies?.first { $0.name == "SESSDATA" } != nil
    }

    /// SESSDATA 的值
    var sessdata: String? {
        storage.cookies?.first { $0.name == "SESSDATA" }?.value
    }

    /// UID Cookie
    var uidCookie: String? {
        storage.cookies?.first { $0.name == "DedeUserID" }?.value
    }
}
