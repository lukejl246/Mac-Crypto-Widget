import Foundation

struct CoinMarketResponse: Codable {
    let data: [Coin]
}

final class CoinMarketService {
    static let shared = CoinMarketService()
    private init() {}

    private let cacheURL: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("coins.json")
    }()

    func fetchCoins() async -> (coins: [Coin], isStale: Bool) {
        do {
            let request = try makeRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(CoinMarketResponse.self, from: data)
            try? data.write(to: cacheURL)
            let filtered = filterCoins(decoded.data)
            return (filtered, false)
        } catch {
            if let data = try? Data(contentsOf: cacheURL),
               let decoded = try? JSONDecoder().decode(CoinMarketResponse.self, from: data) {
                return (filterCoins(decoded.data), true)
            }
            return ([], true)
        }
    }

    private func filterCoins(_ coins: [Coin]) -> [Coin] {
        let selected = Set(UserSettings.shared.coins)
        return coins.filter { selected.contains($0.id) }
    }

    private func makeRequest() throws -> URLRequest {
        let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=10")!
        var request = URLRequest(url: url)
        // Replace with your API key
        request.setValue("YOUR_API_KEY", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        return request
    }
}
