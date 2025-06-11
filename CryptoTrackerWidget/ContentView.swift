import SwiftUI

struct ContentView: View {
    @StateObject private var settings = UserSettings.shared
    @State private var newCoin: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Add coin id", text: $newCoin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    guard !newCoin.isEmpty else { return }
                    settings.coins.append(newCoin)
                    newCoin = ""
                }
            }
            List {
                ForEach(settings.coins, id: \.self) { coin in
                    Text(coin)
                }
                .onMove { indices, newOffset in
                    settings.coins.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indices in
                    settings.coins.remove(atOffsets: indices)
                }
            }
            .toolbar { EditButton() }
            Button("Refresh Widget") {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
