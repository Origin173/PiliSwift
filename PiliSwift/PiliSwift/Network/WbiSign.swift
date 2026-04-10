import Foundation
import CryptoKit

// MARK: - WBI 签名
// 映射自 lib/utils/wbi_sign.dart
// 参考: https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md

actor WbiSign {
    static let shared = WbiSign()

    // 混合键打乱编码表
    private let mixinKeyEncTab: [Int] = [
        46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35,
        27, 43, 5, 49, 33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13
    ]

    // 缓存
    private var mixinKey: String?
    private var cachedDay: Int?

    // 需要过滤的特殊字符
    private let filterChars: CharacterSet = {
        var cs = CharacterSet()
        cs.insert(charactersIn: "!'()*")
        return cs
    }()

    private init() {}

    // MARK: - 核心算法

    /// 对 imgKey + subKey 拼接后做字符顺序打乱
    func getMixinKey(_ orig: String) -> String {
        let chars = Array(orig.unicodeScalars)
        let result = mixinKeyEncTab.compactMap { i -> Character? in
            guard i < chars.count else { return nil }
            return Character(chars[i])
        }
        return String(result)
    }

    /// 对参数进行 WBI 签名，添加 wts 和 w_rid 字段
    func encWbi(_ params: inout [String: String], mixinKey: String) {
        let wts = Int(Date().timeIntervalSince1970)
        params["wts"] = "\(wts)"

        // 按 key 排序
        let sortedKeys = params.keys.sorted()
        let queryString = sortedKeys.map { key -> String in
            let val = (params[key] ?? "")
                .unicodeScalars
                .filter { !filterChars.contains($0) }
                .reduce("") { $0 + String($1) }
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? key
            let encodedVal = val.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? val
            return "\(encodedKey)=\(encodedVal)"
        }.joined(separator: "&")

        let toHash = queryString + mixinKey
        let hash = Insecure.MD5.hash(data: Data(toHash.utf8))
        params["w_rid"] = hash.map { String(format: "%02hhx", $0) }.joined()
    }

    /// 获取当日 WBI Key（带缓存，每日刷新）
    func getWbiKeys() async throws -> String {
        let today = Calendar.current.component(.day, from: Date())
        if let cached = mixinKey, cachedDay == today {
            return cached
        }

        // 从 UserDefaults 读取持久化缓存
        let storedDay = UserDefaults.standard.integer(forKey: "wbi_cached_day")
        if storedDay == today, let stored = UserDefaults.standard.string(forKey: "wbi_mixin_key") {
            self.mixinKey = stored
            self.cachedDay = today
            return stored
        }

        // 拉取新 key
        let key = try await fetchWbiKeys()
        UserDefaults.standard.set(key, forKey: "wbi_mixin_key")
        UserDefaults.standard.set(today, forKey: "wbi_cached_day")
        self.mixinKey = key
        self.cachedDay = today
        return key
    }

    private func fetchWbiKeys() async throws -> String {
        // 请求 /x/web-interface/nav 获取 wbi_img
        struct NavResponse: Decodable {
            struct Data: Decodable {
                struct WbiImg: Decodable {
                    let imgUrl: String
                    let subUrl: String
                    enum CodingKeys: String, CodingKey {
                        case imgUrl = "img_url"
                        case subUrl = "sub_url"
                    }
                }
                let wbiImg: WbiImg
                enum CodingKeys: String, CodingKey {
                    case wbiImg = "wbi_img"
                }
            }
            let code: Int
            let data: Data?
        }

        let response: NavResponse = try await APIClient.shared.get(
            Endpoints.userInfo,
            params: [:]
        )

        guard let data = response.data else {
            throw APIError.serverError(response.code, "Failed to get nav")
        }

        let imgKey = urlFileName(data.wbiImg.imgUrl)
        let subKey = urlFileName(data.wbiImg.subUrl)
        return getMixinKey(imgKey + subKey)
    }

    /// 提取 URL 文件名（不含扩展名），映射 Utils.getFileName
    private func urlFileName(_ urlStr: String) -> String {
        guard let url = URL(string: urlStr) else { return "" }
        return url.deletingPathExtension().lastPathComponent
    }

    // MARK: - Public API

    /// 为参数添加 WBI 签名，返回签名后的参数字典
    func makSign(_ params: [String: String]) async throws -> [String: String] {
        let key = try await getWbiKeys()
        var signed = params
        encWbi(&signed, mixinKey: key)
        return signed
    }
}

// MARK: - URL Query Value 编码扩展
extension CharacterSet {
    static var urlQueryValueAllowed: CharacterSet {
        let generalDelimiters = ":#[]@"
        let subDelimiters = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimiters + subDelimiters)
        return allowed
    }
}
