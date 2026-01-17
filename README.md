# SwiftUICoordinatorKit

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform iOS 17+](https://img.shields.io/badge/Platform-iOS%2017+-blue.svg)](https://developer.apple.com/ios/)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/Documentation-DocC-blue.svg)](https://pavel-vilbik.github.io/SwiftUICoordinatorKit/documentation/swiftuicoordinatorkit/)

A lightweight, protocol-oriented framework for implementing the Coordinator pattern in SwiftUI applications.

## Features

- 🧭 **Navigation Coordinator** — Push/pop navigation with `NavigationStack`
- 📄 **Sheet Coordinator** — Modal sheet presentations
- 📱 **FullScreenCover Coordinator** — Full screen modal presentations
- ⚠️ **Alert Coordinator** — Alert presentations
- ⏳ **Async Flow Coordinators** — Await results from modal flows with `async/await`
- 🎯 **Protocol-oriented** — Compose coordinators by adopting multiple protocols
- 🔒 **Type-safe** — Leverages Swift's type system for compile-time safety

## Requirements

- iOS 17.0+
- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pavel-vilbik/SwiftUICoordinatorKit.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** and enter the repository URL.

## Usage

### Basic Navigation Coordinator

```swift
import SwiftUICoordinatorKit

@Observable
final class HomeCoordinator: NavigationCoordinator {
    var paths = NavigationPath()
    var page: Page = .home
    
    enum Page: Hashable {
        case home
        case details(id: String)
        case settings
    }
    
    @ViewBuilder
    func build(_ page: Page, isAnimated: Bool) -> some View {
        switch page {
        case .home:
            HomeView(coordinator: self)
        case .details(let id):
            DetailsView(id: id, coordinator: self)
        case .settings:
            SettingsView(coordinator: self)
        }
    }
}

// In your SwiftUI view:
struct ContentView: View {
    @State var coordinator = HomeCoordinator()
    
    var body: some View {
        CoordinatorNavigationView(coordinator: coordinator)
    }
}
```

### Adding Sheet Support

```swift
@Observable
final class HomeCoordinator: NavigationCoordinator, SheetCoordinator {
    var paths = NavigationPath()
    var page: Page = .home
    var sheet: Sheet?
    
    enum Page: Hashable { /* ... */ }
    
    enum Sheet: Identifiable {
        case createItem
        case editItem(id: String)
        
        var id: String {
            switch self {
            case .createItem: return "create"
            case .editItem(let id): return "edit-\(id)"
            }
        }
    }
    
    @ViewBuilder
    func build(_ page: Page, isAnimated: Bool) -> some View { /* ... */ }
    
    @ViewBuilder
    func buildSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .createItem:
            CreateItemView(coordinator: self)
        case .editItem(let id):
            EditItemView(id: id, coordinator: self)
        }
    }
}

// Usage in view:
CoordinatorNavigationView(coordinator: coordinator)
    .sheet(coordinator: coordinator)
```

### Async Flow Coordinator (Awaiting Results)

The most powerful feature — present a modal flow and await its result:

```swift
@Observable
final class OnboardingCoordinator: NavigationCoordinator, AsyncSheetCoordinator {
    var paths = NavigationPath()
    var page: Page = .welcome
    var sheet: Sheet?
    
    // AsyncFlowCoordinator requirements
    var flowContinuation: CheckedContinuation<FlowResult, Never>?
    var pendingFlowResult: FlowResult?
    var defaultFlowResult: FlowResult { .cancelled }
    
    enum FlowResult: Sendable {
        case completed(user: User)
        case cancelled
    }
    
    enum Page: Hashable {
        case welcome
        case createAccount
        case login
    }
    
    enum Sheet: Identifiable {
        case onboarding
        var id: String { "onboarding" }
    }
    
    // Start flow presentation
    func startFlowPresentation() {
        presentSheet(.onboarding)
    }
    
    // Reset state after flow completes
    func resetFlowState() {
        popToRoot()
    }
    
    // Call this when user completes onboarding
    func completeOnboarding(user: User) {
        finishFlow(with: .completed(user: user))
    }
    
    @ViewBuilder
    func build(_ page: Page, isAnimated: Bool) -> some View { /* ... */ }
    
    @ViewBuilder
    func buildSheet(_ sheet: Sheet) -> some View {
        CoordinatorNavigationView(coordinator: self)
    }
}

// Usage — await the result!
let coordinator = OnboardingCoordinator()
let result = await coordinator.run()

switch result {
case .completed(let user):
    print("User signed up: \(user.name)")
case .cancelled:
    print("User cancelled onboarding")
}
```

### Full Screen Cover

```swift
@Observable
final class AppCoordinator: NavigationCoordinator, FullScreenCoverCoordinator {
    var paths = NavigationPath()
    var page: Page = .main
    var fullScreenCover: FullScreenCover?
    
    enum FullScreenCover: Identifiable {
        case player(videoId: String)
        var id: String { /* ... */ }
    }
    
    @ViewBuilder
    func buildFullScreenCover(_ cover: FullScreenCover) -> some View {
        switch cover {
        case .player(let videoId):
            VideoPlayerView(videoId: videoId)
        }
    }
}

// Usage:
CoordinatorNavigationView(coordinator: coordinator)
    .fullScreenCover(coordinator: coordinator)
```

### Alerts

```swift
@Observable
final class SettingsCoordinator: NavigationCoordinator, AlertCoordinator {
    var paths = NavigationPath()
    var page: Page = .settings
    var alertItem: AlertItem?
    
    struct AlertItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let action: () -> Void
    }
    
    func buildAlert(_ alertItem: AlertItem) -> Alert {
        Alert(
            title: Text(alertItem.title),
            message: Text(alertItem.message),
            primaryButton: .destructive(Text("Confirm"), action: alertItem.action),
            secondaryButton: .cancel()
        )
    }
    
    func showDeleteConfirmation() {
        presentAlert(AlertItem(
            title: "Delete Account",
            message: "Are you sure?",
            action: { self.deleteAccount() }
        ))
    }
}

// Usage:
CoordinatorNavigationView(coordinator: coordinator)
    .alert(coordinator: coordinator)
```

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUICoordinatorKit                    │
├─────────────────────────────────────────────────────────────┤
│  Protocols                                                  │
│  ├── NavigationCoordinator     (push/pop navigation)        │
│  ├── SheetCoordinator          (sheet presentations)        │
│  ├── FullScreenCoverCoordinator                             │
│  ├── AlertCoordinator          (alert presentations)        │
│  └── AsyncFlow/                                             │
│      ├── AsyncFlowCoordinator  (await flow results)         │
│      ├── AsyncSheetCoordinator                              │
│      └── AsyncFullScreenCoverCoordinator                    │
├─────────────────────────────────────────────────────────────┤
│  Views                                                      │
│  ├── CoordinatorNavigationView (NavigationStack wrapper)    │
│  └── Modifiers/                                             │
│      ├── SheetModifier         (.sheet extension)           │
│      ├── FullScreenCoverModifier                            │
│      └── AlertModifier         (.alert extension)           │
└─────────────────────────────────────────────────────────────┘
```

## Combining Multiple Protocols

Coordinators can adopt multiple protocols to support various presentation styles:

```swift
@Observable
final class MainCoordinator: NavigationCoordinator, 
                              SheetCoordinator, 
                              FullScreenCoverCoordinator,
                              AlertCoordinator {
    // Implement all required properties and methods
}

// Apply all modifiers:
CoordinatorNavigationView(coordinator: coordinator)
    .sheet(coordinator: coordinator)
    .fullScreenCover(coordinator: coordinator)
    .alert(coordinator: coordinator)
```

## Documentation

Full API documentation is available at [GitHub Pages](https://pavel-vilbik.github.io/SwiftUICoordinatorKit/documentation/swiftuicoordinatorkit/).

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
