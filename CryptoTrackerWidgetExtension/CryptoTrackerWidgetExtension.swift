import WidgetKit
import SwiftUI

struct CoinEntry: TimelineEntry {
    let date: Date
    let coins: [Coin]
    let isStale: Bool
}

struct Coin: Identifiable, Codable {
    let id: String
    let name: String
    let price: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CoinEntry {
        CoinEntry(date: Date(), coins: [], isStale: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (CoinEntry) -> ()) {
        loadCoins { coins, isStale in
            completion(CoinEntry(date: Date(), coins: coins, isStale: isStale))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CoinEntry>) -> ()) {
        loadCoins { coins, isStale in
            let entry = CoinEntry(date: Date(), coins: coins, isStale: isStale)
            // Refresh after 30 minutes
            let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }

    private func loadCoins(completion: @escaping ([Coin], Bool) -> Void) {
        Task {
            let service = CoinMarketService.shared
            let result = await service.fetchCoins()
            completion(result.coins, result.isStale)
        }
    }
}

struct CryptoTrackerWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(entry.coins.prefix(4)) { coin in
                HStack {
                    Text(coin.name)
                    Spacer()
                    Text("$\(coin.price, specifier: "%.2f")")
                }
            }
            if entry.isStale {
                Text("Stale data")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct CryptoTrackerWidgetExtension: Widget {
    let kind: String = "CryptoTrackerWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CryptoTrackerWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto Tracker")
        .description("Tracks crypto prices")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    CryptoTrackerWidgetExtension()
} timeline: {
    CoinEntry(date: .now, coins: [], isStale: false)
}
