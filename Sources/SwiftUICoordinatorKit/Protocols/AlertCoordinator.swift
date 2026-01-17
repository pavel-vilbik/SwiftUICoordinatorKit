//
//  AlertCoordinator.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - AlertCoordinator

/// Protocol for coordinators that support alert presentation.
/// Adopt this protocol in addition to NavigationCoordinator
/// when you need alert capabilities.
@MainActor
public protocol AlertCoordinator: Observable, AnyObject {
    associatedtype AlertItem: Identifiable
    
    /// Currently presented alert item, if any.
    var alertItem: AlertItem? { get set }
    
    /// Builds the alert for the specified item.
    /// - Parameter alertItem: The alert item to build the alert for.
    /// - Returns: An Alert representing the alert content.
    func buildAlert(_ alertItem: AlertItem) -> Alert
}

// MARK: - Default Alert Actions

public extension AlertCoordinator {
    /// Presents an alert with the specified item.
    /// - Parameter alertItem: The alert item to present.
    func presentAlert(_ alertItem: AlertItem) {
        self.alertItem = alertItem
    }
    
    /// Dismisses the currently presented alert.
    func dismissAlert() {
        self.alertItem = nil
    }
}

