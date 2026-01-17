//
//  FullScreenCoverModifier.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - FullScreenCoverModifier

/// A view modifier that adds full screen cover capability to any view.
/// Use this modifier with coordinators that conform to FullScreenCoverCoordinator.
public struct FullScreenCoverModifier<Coordinator: FullScreenCoverCoordinator>: ViewModifier {
    @Bindable var coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $coordinator.fullScreenCover, onDismiss: {
                coordinator.onFullScreenCoverDismiss()
            }) { fullScreenCover in
                coordinator.buildFullScreenCover(fullScreenCover)
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds full screen cover capability using the specified coordinator.
    /// - Parameter coordinator: The coordinator that manages full screen cover.
    /// - Returns: A view with full screen cover capability.
    func fullScreenCover<Coordinator: FullScreenCoverCoordinator>(
        coordinator: Coordinator
    ) -> some View {
        modifier(FullScreenCoverModifier(coordinator: coordinator))
    }
}

