import Foundation
import UIKit
import Observation

/// 登录 ViewModel（二维码登录）
/// 对应 Flutter: lib/pages/login/controller.dart
@Observable
final class LoginViewModel {
    private(set) var qrImage: UIImage? = nil
    private(set) var isLoadingQR = false
    private(set) var isLoggedIn = false
    private(set) var errorMessage: String? = nil
    private var qrKey = ""
    private var pollTask: Task<Void, Never>? = nil

    func fetchQRCode() async {
        isLoadingQR = true
        qrImage = nil
        do {
            // 1. 获取二维码 key
            let resp: APIResponse<QRCodeData> = try await APIClient.shared.get(
                APIEndpoints.loginQRGenerate, params: [:]
            )
            guard let data = resp.data else { return }
            qrKey = data.qrcodeKey
            // 2. 生成二维码图片
            if let img = generateQRCode(from: data.url) {
                qrImage = img
            }
            isLoadingQR = false
            // 3. 开始轮询登录状态
            startPolling()
        } catch {
            isLoadingQR = false
            errorMessage = error.localizedDescription
        }
    }

    private func startPolling() {
        pollTask?.cancel()
        pollTask = Task {
            while !Task.isCancelled && !isLoggedIn {
                try? await Task.sleep(for: .seconds(2))
                await checkQRStatus()
            }
        }
    }

    private func checkQRStatus() async {
        do {
            let resp: APIResponse<QRStatusData> = try await APIClient.shared.get(
                APIEndpoints.loginQRPoll,
                params: ["qrcode_key": qrKey, "source": "main-mini-header"]
            )
            switch resp.data?.code {
            case 0:     // 扫码成功
                isLoggedIn = true
                pollTask?.cancel()
                // 保存凭证
                if let cookieStr = resp.data?.cookieInfo?.cookies.first(where: { $0.name == "SESSDATA" })?.value {
                    AccountStorage.shared.saveSession(sessdata: cookieStr, biliJct: "", buvid3: "")
                }
            case 86038: // 二维码已过期
                pollTask?.cancel()
                errorMessage = "二维码已过期，请刷新"
            default:
                break   // 86090=已扫码待确认，86101=未扫描
            }
        } catch {}
    }

    private func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let ciImage = filter.outputImage else { return nil }
        let scale = 200.0 / ciImage.extent.width
        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        return UIImage(ciImage: scaled)
    }
}

// MARK: - 登录 API 模型
struct QRCodeData: Codable {
    let url: String
    let qrcodeKey: String
    enum CodingKeys: String, CodingKey {
        case url
        case qrcodeKey = "qrcode_key"
    }
}

struct QRStatusData: Codable {
    let url: String?
    let refreshToken: String?
    let timestamp: Int64?
    let code: Int?
    let message: String?
    let cookieInfo: CookieInfo?

    struct CookieInfo: Codable {
        let cookies: [CookieItem]
        struct CookieItem: Codable {
            let name: String
            let value: String
        }
    }

    enum CodingKeys: String, CodingKey {
        case url, timestamp, code, message
        case refreshToken = "refresh_token"
        case cookieInfo   = "cookie_info"
    }
}
