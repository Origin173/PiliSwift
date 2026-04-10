import Foundation

// MARK: - API 错误类型
enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case serverError(Int, String)
    case decodingError(Error)
    case unauthorized
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:              return "无效的 URL"
        case .networkError(let e):     return "网络错误：\(e.localizedDescription)"
        case .serverError(let c, let m): return "服务器错误 \(c)：\(m)"
        case .decodingError(let e):    return "数据解析错误：\(e.localizedDescription)"
        case .unauthorized:            return "未登录或登录已过期"
        case .noData:                  return "无数据"
        }
    }
}

// MARK: - 服务器通用响应结构
struct APIResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case code, message, data
    }

    var isSuccess: Bool { code == 0 }
}

// MARK: - API 客户端
// 映射自 lib/http/init.dart 中的 Request 类

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let baseURL = URL(string: BaseURL.api)!
    private let jsonDecoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 30
        config.httpShouldSetCookies = true
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpCookieAcceptPolicy = .always
        config.httpAdditionalHeaders = [
            "Accept-Encoding": "gzip",
            "Connection":       "keep-alive",
        ]
        session = URLSession(configuration: config)

        jsonDecoder = JSONDecoder()
        // Bilibili API 使用 snake_case；各模型自定义 CodingKeys 优先
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
    }

    // MARK: - GET 请求

    /// GET 请求，自动解码为 APIResponse<T>
    func get<T: Decodable>(
        _ path: String,
        params: [String: String] = [:],
        headers: [String: String] = [:],
        baseURLOverride: String? = nil
    ) async throws -> T {
        let url = try buildURL(path: path, params: params, baseURLOverride: baseURLOverride)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        applyHeaders(to: &request, extra: headers)
        return try await perform(request)
    }

    /// GET 请求，带 WBI 签名
    func getWbi<T: Decodable>(
        _ path: String,
        params: [String: String] = [:],
        headers: [String: String] = [:]
    ) async throws -> T {
        let signed = try await WbiSign.shared.makSign(params)
        return try await get(path, params: signed, headers: headers)
    }

    // MARK: - POST 请求 (form-urlencoded)

    func post<T: Decodable>(
        _ path: String,
        params: [String: String] = [:],
        headers: [String: String] = [:],
        baseURLOverride: String? = nil
    ) async throws -> T {
        let url = try buildURL(path: path, params: [:], baseURLOverride: baseURLOverride)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        applyHeaders(to: &request, extra: headers)
        return try await perform(request)
    }

    /// POST 请求，body 为 JSON
    func postJSON<T: Decodable>(
        _ path: String,
        body: some Encodable,
        headers: [String: String] = [:],
        baseURLOverride: String? = nil
    ) async throws -> T {
        let url = try buildURL(path: path, params: [:], baseURLOverride: baseURLOverride)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        applyHeaders(to: &request, extra: headers)
        return try await perform(request)
    }

    // MARK: - 私有辅助

    private func buildURL(path: String, params: [String: String], baseURLOverride: String?) throws -> URL {
        let base: URL
        if let override = baseURLOverride, let u = URL(string: override) {
            base = u
        } else if path.hasPrefix("http://") || path.hasPrefix("https://") {
            guard let u = URL(string: path) else { throw APIError.invalidURL }
            base = u
        } else {
            base = baseURL
        }

        var components: URLComponents
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            guard var c = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
                throw APIError.invalidURL
            }
            components = c
        } else {
            guard var c = URLComponents(url: base.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
                throw APIError.invalidURL
            }
            components = c
        }

        if !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else { throw APIError.invalidURL }
        return url
    }

    private func applyHeaders(to request: inout URLRequest, extra: [String: String]) {
        let headers = RequestHeaders.build(extra: extra)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }

        // 更新 Cookie
        if let headerFields = httpResponse.allHeaderFields as? [String: String],
           let url = request.url {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            CookieManager.shared.setCookies(cookies, for: url)
        }

        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            throw APIError.serverError(httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
        }

        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
