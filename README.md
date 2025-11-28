# 📈 PriceTracker

A real-time stock price tracking iOS application built with **SwiftUI**, **Combine**, and **Clean Architecture**.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

---

## ✨ Features

### Core Features
- 📊 **Live Price Tracking** — Real-time updates for 25 tech stock symbols
- 🔌 **WebSocket Integration** — Native `URLSessionWebSocketTask` for live data streaming
- 📱 **Feed Screen** — Dynamic list sorted by price (highest first)
- 🔍 **Symbol Details** — Detailed view with real-time price updates
- 🟢 **Connection Status** — Visual indicator showing WebSocket connection state
- ▶️ **Start/Stop Control** — Manual control over the price feed
- ↕️ **Change Indicators** — Up/down arrows showing price movement

### Bonus Features
- ⚡ **Price Flash Animation** — Color flash effect on price changes (green/red)
- 🌓 **Dark/Light Theme** — Automatic theme support
- 🔗 **Deep Linking** — Navigate directly to symbols via `stocks://symbol/{SYMBOL}`
- ✅ **Unit Tests** — Comprehensive test coverage for ViewModels

---

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **MVVM** pattern using **Combine** for reactive state management.

```
┌─────────────────────────────────────────────────────────────────┐
│                               VIEW                              │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │  FeedView   │  │ StockRowView │  │   SymbolDetailView      │ │
│  └──────┬──────┘  └──────────────┘  └───────────┬─────────────┘ │
└─────────┼───────────────────────────────────────┼───────────────┘
          │                                       │
          ▼                                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                            VIEWMODEL                            │
│  ┌────────────────────┐           ┌─────────────────────────┐   │
│  │   FeedViewModel    │           │  SymbolDetailViewModel  │   │
│  │   @Published       │           │      @Published         │   │
│  └─────────┬──────────┘           └────────────┬────────────┘   │
└────────────┼───────────────────────────────────┼────────────────┘
             │                                   │
             ▼                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                             USE CASE                            │
│  ┌─────────────────────┐        ┌─────────────────────────────┐ │
│  │ FetchSymbolsUseCase │        │     PriceFeedUseCase        │ │
│  └──────────┬──────────┘        └──────────────┬──────────────┘ │
└─────────────┼──────────────────────────────────┼────────────────┘
              │                                  │
              ▼                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                          REPOSITORY                             │
│                  ┌─────────────────────────┐                    │
│                  │   PriceRepositoryImpl   │                    │
│                  └────────────┬────────────┘                    │
└───────────────────────────────┼─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                             DATA                                │
│  ┌─────────────────────┐        ┌─────────────────────────────┐ │
│  │ WebSocketDataSource │        │      PriceGenerator         │ │
│  │ (URLSessionTask)    │        │    (Mock Price Data)        │ │
│  └─────────────────────┘        └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Component | Responsibility |
|-------|-----------|----------------|
| **View** | SwiftUI Views | UI rendering, user interaction |
| **ViewModel** | `ObservableObject` | State management, UI logic |
| **Use Case** | Business Logic | Single responsibility operations |
| **Repository** | Data Abstraction | Protocol-based data access |
| **Data Source** | I/O Operations | WebSocket, data generation |

---

## 📁 Project Structure

```
PriceTracker/
├── 📱 PriceTrackerApp.swift          # App entry point
├── 🏭 AppFactory.swift               # Dependency injection
│
├── 📦 Data/
│   ├── DataSources/
│   │   ├── PriceGenerator.swift      # Mock price generation
│   │   ├── SymbolGenerator.swift     # Symbol list generator
│   │   └── WebSocketDataSource.swift # WebSocket handling
│   └── Repo/
│       └── PriceRepositoryImpl.swift # Repository implementation
│
├── 🎯 Domain/
│   ├── Entities/
│   │   ├── StockSymbol.swift        # Core business model
│   │   └── PriceUpdate.swift        # Price update model
│   ├── Repo/
│   │   └── PriceRepositoryProtocol.swift
│   └── Usecase/
│       ├── FetchSymbolsUseCase.swift
│       ├── PriceFeedUseCase.swift
│       └── StreamingUsecaseProtocol.swift
│
├── 🧩 Modules/
│   ├── Common/
│   │   └── FlashingPriceView.swift   # Reusable price component
│   ├── Detail/
│   │   ├── View/SymbolDetailView.swift
│   │   └── ViewModel/SymbolDetailViewModel.swift
│   └── Feed/
│       ├── View/
│       │   ├── FeedView.swift
│       │   └── StockRowView.swift
│       └── ViewModel/FeedViewModel.swift
│
└── 🧭 Navigation/
    ├── DeepLink.swift                # Deep link parsing
    ├── Route.swift                   # Navigation routes
    └── Router.swift                  # Centralized navigation
```

---

## 📊 Stock Symbols

The app tracks **25 technology stocks**:

```
AAPL   GOOG   TSLA   AMZN   MSFT
NVDA   META   NFLX   AMD    INTC
ORCL   CRM    ADBE   CSCO   AVGO
QCOM   TXN    AMAT   LRCX   KLAC
SNPS   CDNS   MRVL   WDAY   ZS
```

---

## 🚀 Getting Started

### Requirements

- **iOS 16.0+**
- **Xcode 15.0+**
- **Swift 5.9+**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/PriceTracker.git
   cd PriceTracker
   ```

2. **Open in Xcode**
   ```bash
   open PriceTracker.xcodeproj
   ```

3. **Build and Run**
   - Select a simulator or device (iOS 16.0+)
   - Press `⌘R` to build and run

---

## 🔌 WebSocket Integration

The app uses native `URLSessionWebSocketTask` to connect to an echo server for simulating real-time data:

```
wss://ws.postman-echo.com/raw
```

### How It Works

1. **Connect** — Establishes WebSocket connection on "Start"
2. **Send** — Broadcasts price updates every 2 seconds for all symbols
3. **Receive** — Echoed messages are parsed and update the UI
4. **Disconnect** — Cleanly closes connection on "Stop"

### Combine Publishers

| Publisher | Type | Purpose |
|-----------|------|---------|
| `priceUpdates` | `PassthroughSubject` | Emits price update events |
| `connectionStatus` | `CurrentValueSubject` | Tracks connection state |

---

## 🔗 Deep Linking

Navigate directly to a symbol's detail view:

```
stocks://symbol/AAPL    → Opens Apple details
stocks://symbol/TSLA    → Opens Tesla details
stocks://symbol/NVDA    → Opens NVIDIA details
```

### Testing Deep Links

In Terminal:
```bash
xcrun simctl openurl booted "stocks://symbol/AAPL"
```

---

## 🧪 Testing

### Unit Tests

Run unit tests with `⌘U` or:

```bash
xcodebuild test -scheme PriceTracker -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Test Coverage:**
- `FeedViewModelTests` — Feed state management
- `SymbolDetailViewModelTests` — Detail screen logic

### UI Tests

```bash
xcodebuild test -scheme PriceTrackerUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 🛠️ Key Technologies

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | Declarative UI framework |
| **Combine** | Reactive programming |
| **URLSessionWebSocketTask** | Native WebSocket support |
| **NavigationStack** | Type-safe navigation (iOS 16+) |
| **@MainActor** | Thread-safe UI updates |

---

## 📐 Design Patterns

- **Clean Architecture** — Separation of concerns across layers
- **MVVM** — Model-View-ViewModel for UI binding
- **Repository Pattern** — Abstract data access
- **Use Case Pattern** — Encapsulate business logic
- **Dependency Injection** — Via `AppFactory` for testability
- **Protocol-Oriented** — Interfaces for mocking in tests

---

## 🎨 UI Highlights

### Price Flash Animation

The `FlashingPriceView` component provides visual feedback:
- 🟢 **Green flash** — Price increased
- 🔴 **Red flash** — Price decreased
- Uses `contentTransition(.numericText())` for smooth number animations

### Connection Status

Real-time connection indicator:
- 🟢 **Green dot** — Connected to WebSocket
- 🔴 **Red dot** — Disconnected

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Ahmed Allam**

---

<p align="center">
  Made with ❤️ using SwiftUI & Combine
</p>

