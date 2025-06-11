import SwiftUI

@main
struct CryptoTrackerWidgetApp: App {
    init() {
        UserSettings.shared.load()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
