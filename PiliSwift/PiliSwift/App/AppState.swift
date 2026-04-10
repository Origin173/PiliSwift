import SwiftUI
import Observation

/// 全局应用状态（映射 Flutter 端的 AccountService + GlobalData）
@Observable
final class AppState {
    // MARK: - 账号状态
    var isLoggedIn: Bool = false
    var uid: Int64 = 0
    var username: String = ""
    var faceURL: String = ""
    var coins: Double = 0

    // MARK: - 未读消息数
    var unreadDynamic: Int = 0
    var unreadReply: Int = 0
    var unreadAt: Int = 0
    var unreadLike: Int = 0
    var unreadMsg: Int = 0

    // MARK: - 播放器状态（迷你播放器）
    var miniPlayerVisible: Bool = false

    // MARK: - 主题设置
    var colorScheme: ColorScheme? = nil          // nil = 跟随系统

    // MARK: - 帮助方法
    func updateAccount(uid: Int64, username: String, faceURL: String) {
        self.uid = uid
        self.username = username
        self.faceURL = faceURL
        self.isLoggedIn = uid != 0
    }

    func logout() {
        uid = 0
        username = ""
        faceURL = ""
        coins = 0
        isLoggedIn = false
        AccountStorage.shared.clearSession()
    }

    /// 登录成功后刷新用户信息（从 API 拉取）
    func refreshUserInfo() async {
        do {
            let resp: APIResponse<UserInfoData> = try await APIClient.shared.get(
                APIEndpoints.myInfo, params: [:]
            )
            if let data = resp.data, data.mid != 0 {
                updateAccount(uid: data.mid, username: data.uname, faceURL: data.face)
                UserDefaults.standard.set(data.mid, forKey: "current_uid")
                UserDefaults.standard.set(data.uname, forKey: "current_username")
                UserDefaults.standard.set(data.face, forKey: "current_face_url")
            }
        } catch {}
    }
}
