import Foundation
import Security

// MARK: - 账号 Keychain 存储
// 映射自 lib/utils/accounts/ 下的账号管理逻辑

final class AccountStorage {
    static let shared = AccountStorage()

    private let service = "com.piliswift.accounts"

    private init() {}

    // MARK: - 会话恢复

    /// 从 Keychain + UserDefaults 恢复登录状态
    func restoreSession() {
        CookieManager.shared.restore()
    }

    /// 清除当前账号的所有会话数据
    func clearSession() {
        CookieManager.shared.clearAll()
        UserDefaults.standard.removeObject(forKey: "current_uid")
        UserDefaults.standard.removeObject(forKey: "current_username")
        UserDefaults.standard.removeObject(forKey: "current_face_url")
    }

    // MARK: - Cookie 字符串（用于请求头）
    var cookieString: String? {
        guard let url = URL(string: BaseURL.api) else { return nil }
        let str = CookieManager.shared.cookieString(for: url)
        return str.isEmpty ? nil : str
    }

    // MARK: - 已登录信息（从 Cookie 读取）
    var isLoggedIn: Bool {
        CookieManager.shared.hasSession
    }

    var currentUid: Int64 {
        guard let uidStr = CookieManager.shared.uidCookie else { return 0 }
        return Int64(uidStr) ?? 0
    }

    // MARK: - Keychain 操作

    /// 保存登录 Cookie（SESSDATA 等）
    func saveSession(sessdata: String, biliJct: String, buvid3: String) {
        if !sessdata.isEmpty { saveToken(sessdata, forKey: KeychainKey.sessdata) }
        if !biliJct.isEmpty  { saveToken(biliJct,  forKey: KeychainKey.biliJct) }
        if !buvid3.isEmpty   { saveToken(buvid3,   forKey: KeychainKey.buvid3) }
    }

    /// 当前登录用户 UID（供 ViewModel 使用）
    var uid: Int64? {
        let u = currentUid
        return u == 0 ? nil : u
    }

    func saveToken(_ token: String, forKey key: String) {
        let data = Data(token.utf8)
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecValueData:        data,
            kSecAttrAccessible:   kSecAttrAccessibleAfterFirstUnlock,
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func loadToken(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecReturnData:       true,
            kSecMatchLimit:       kSecMatchLimitOne,
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else { return nil }
        return token
    }

    func deleteToken(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Keychain Keys
enum KeychainKey {
    static let sessdata    = "sessdata"
    static let biliJct     = "bili_jct"
    static let buvid3      = "buvid3"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
}
