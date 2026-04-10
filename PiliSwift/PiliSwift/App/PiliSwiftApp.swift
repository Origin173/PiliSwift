import SwiftUI

@main
struct PiliSwiftApp: App {
    @State private var appState = AppState()
    @State private var router = Router()

    init() {
        // 初始化存储
        Preferences.shared.setup()
        // 初始化账号
        AccountStorage.shared.restoreSession()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(router)
                .onOpenURL { url in
                    router.handleDeepLink(url)
                }
        }
    }
}
