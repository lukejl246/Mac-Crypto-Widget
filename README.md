# Mac Crypto Widget

This repository contains a macOS widget that displays cryptocurrency prices using data from CoinMarketCap.

## Build steps
1. Install Xcode 15 or later.
2. Clone this repository and open the project in Xcode:
   ```bash
   git clone <repository-url>
   cd Mac-Crypto-Widget
   open MacCryptoWidget.xcodeproj
   ```
3. Insert your CoinMarketCap API key in `Sources/MacCryptoWidget/Secrets.swift` by replacing the `CMC_API_KEY` placeholder.
4. Adjust the cache duration in `Sources/MacCryptoWidget/CoinService.swift` by modifying the `cacheDuration` constant (in seconds).
5. Build the widget by selecting the **MacCryptoWidget** scheme and pressing **⌘B** or by running `swift build` from the command line.

## Running on macOS 15
1. Run the built application.
2. Open the widget gallery (from Notification Center) and search for **Mac Crypto Widget**.
3. Select a size and add it to your dashboard.

## Running on macOS 26
macOS 26 uses the same widget gallery approach. After building the project in Xcode 26, open the widget gallery, search for **Mac Crypto Widget**, and add it to your desktop or Notification Center.

## Notes
- Increasing the cache duration reduces API requests but may result in less frequent price updates.
- A free CoinMarketCap developer account is sufficient for the default settings.
