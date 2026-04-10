import Foundation

// MARK: - 加载状态枚举
// 映射自 lib/http/loading_state.dart 的 sealed class LoadingState<T>

enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case error(String?, Int?)

    // MARK: - 便捷属性

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    var data: T? {
        if case .success(let value) = self { return value }
        return nil
    }

    var errorMessage: String? {
        if case .error(let msg, _) = self { return msg }
        return nil
    }

    var errorCode: Int? {
        if case .error(_, let code) = self { return code }
        return nil
    }

    // MARK: - 转换

    func map<U>(_ transform: (T) -> U) -> LoadingState<U> {
        switch self {
        case .idle:             return .idle
        case .loading:          return .loading
        case .success(let v):   return .success(transform(v))
        case .error(let m, let c): return .error(m, c)
        }
    }
}

// MARK: - 从 APIResponse 构建 LoadingState
extension LoadingState {
    /// 从 Bilibili 标准 APIResponse<T> 构建
    static func from<R>(_ response: APIResponse<R>) -> LoadingState<R> {
        if response.code == 0, let data = response.data {
            return .success(data)
        } else {
            return .error(response.message ?? "未知错误", response.code)
        }
    }

    /// 从 async throw 方法安全执行并返回 LoadingState
    static func run<R>(_ block: () async throws -> R) async -> LoadingState<R> {
        do {
            let result = try await block()
            return .success(result)
        } catch let apiError as APIError {
            switch apiError {
            case .serverError(let code, let msg):
                return .error(msg, code)
            case .unauthorized:
                return .error("未登录或登录已过期", 401)
            default:
                return .error(apiError.localizedDescription, nil)
            }
        } catch {
            return .error(error.localizedDescription, nil)
        }
    }
}
