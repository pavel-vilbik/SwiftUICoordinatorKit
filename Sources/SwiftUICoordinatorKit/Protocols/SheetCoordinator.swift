//
//  SheetCoordinator.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - SheetCoordinator

/// Protocol for coordinators that support sheet presentation.
/// Adopt this protocol in addition to NavigationCoordinator
/// when you need modal sheet capabilities.
@MainActor
public protocol SheetCoordinator: Observable, AnyObject {
    associatedtype Sheet: Identifiable
    associatedtype SheetContent: View
    
    /// Currently presented sheet, if any.
    var sheet: Sheet? { get set }
    
    /// Builds the view for the specified sheet.
    /// - Parameter sheet: The sheet to build the view for.
    /// - Returns: A view representing the sheet content.
    @ViewBuilder
    func buildSheet(_ sheet: Sheet) -> SheetContent
    
    /// Called after the sheet is fully dismissed.
    /// Override this method to perform actions that depend on the sheet being completely closed.
    func onSheetDismiss()
}

// MARK: - Default Implementation

public extension SheetCoordinator {
    /// Default empty implementation - override if needed.
    func onSheetDismiss() {}
}

// MARK: - Default Sheet Actions

public extension SheetCoordinator {
    /// Presents a sheet with the specified content.
    /// - Parameter sheet: The sheet to present.
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    /// Dismisses the currently presented sheet.
    func dismissSheet() {
        self.sheet = nil
    }
}

