//
//  CoordinatorNavigationView.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - CoordinatorNavigationView

/// A view that wraps a coordinator's navigation stack.
/// Use this view as the base for coordinator-driven navigation.
///
/// Example usage:
/// ```swift
/// CoordinatorNavigationView(coordinator: myCoordinator)
///     .sheet(coordinator: myCoordinator)  // optional
///     .fullScreenCover(coordinator: myCoordinator)  // optional
/// ```
public struct CoordinatorNavigationView<Coordinator: NavigationCoordinator>: View {
    @State var coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self._coordinator = State(initialValue: coordinator)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.paths) {
            coordinator.build(coordinator.page, isAnimated: false)
                .navigationDestination(for: Coordinator.Page.self) {
                    coordinator.build($0, isAnimated: true)
                }
        }
    }
}

