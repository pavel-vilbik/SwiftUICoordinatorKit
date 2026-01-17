//
//  AlertModifier.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - AlertModifier

/// A view modifier that adds alert capability to any view.
/// Use this modifier with coordinators that conform to AlertCoordinator.
public struct AlertModifier<Coordinator: AlertCoordinator>: ViewModifier {
    @Bindable var coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    public func body(content: Content) -> some View {
        content
            .alert(item: $coordinator.alertItem) { alertItem in
                coordinator.buildAlert(alertItem)
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds alert capability using the specified coordinator.
    /// - Parameter coordinator: The coordinator that manages alert.
    /// - Returns: A view with alert capability.
    func alert<Coordinator: AlertCoordinator>(
        coordinator: Coordinator
    ) -> some View {
        modifier(AlertModifier(coordinator: coordinator))
    }
}

