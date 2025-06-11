import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    private init() {
        coins = defaults.stringArray(forKey: "coins") ?? ["bitcoin", "ethereum", "solana"]
    }

    private let defaults = UserDefaults(suiteName: "group.com.example.CryptoTracker")!
    @Published var coins: [String] {
        didSet { defaults.set(coins, forKey: "coins") }
    }
}
