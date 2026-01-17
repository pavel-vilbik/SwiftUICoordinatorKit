//
//  SheetModifier.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - SheetModifier

/// A view modifier that adds sheet capability to any view.
/// Use this modifier with coordinators that conform to SheetCoordinator.
public struct SheetModifier<Coordinator: SheetCoordinator>: ViewModifier {
    @Bindable var coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.sheet, onDismiss: {
                coordinator.onSheetDismiss()
            }) { sheet in
                coordinator.buildSheet(sheet)
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds sheet capability using the specified coordinator.
    /// - Parameter coordinator: The coordinator that manages sheet.
    /// - Returns: A view with sheet capability.
    func sheet<Coordinator: SheetCoordinator>(
        coordinator: Coordinator
    ) -> some View {
        modifier(SheetModifier(coordinator: coordinator))
    }
}

