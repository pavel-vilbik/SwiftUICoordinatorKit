# ``SwiftUICoordinatorKit``

A lightweight, protocol-oriented framework for implementing the Coordinator pattern in SwiftUI applications.

## Overview

SwiftUICoordinatorKit provides a set of protocols that make it easy to implement the Coordinator pattern in SwiftUI. The framework is designed to be composable — you can adopt multiple protocols to support various presentation styles.

### Key Features

- **Navigation Coordinator** — Push/pop navigation with `NavigationStack`
- **Sheet Coordinator** — Modal sheet presentations
- **FullScreenCover Coordinator** — Full screen modal presentations
- **Alert Coordinator** — Alert presentations
- **Async Flow Coordinators** — Await results from modal flows with `async/await`

## Topics

### Essentials

- ``NavigationCoordinator``
- ``CoordinatorNavigationView``

### Modal Presentations

- ``SheetCoordinator``
- ``FullScreenCoverCoordinator``
- ``AlertCoordinator``

### Async Flows

- ``AsyncFlowCoordinator``
- ``AsyncSheetCoordinator``
- ``AsyncFullScreenCoverCoordinator``

### View Modifiers

- ``SheetModifier``
- ``FullScreenCoverModifier``
- ``AlertModifier``
