//
//  FullScreenCoverCoordinator.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - FullScreenCoverCoordinator

/// Protocol for coordinators that support full screen cover presentation.
/// Adopt this protocol in addition to NavigationCoordinator
/// when you need modal full screen cover capabilities.
@MainActor
public protocol FullScreenCoverCoordinator: Observable, AnyObject {
    associatedtype FullScreenCover: Identifiable
    associatedtype FullScreenCoverContent: View
    
    /// Currently presented full screen cover, if any.
    var fullScreenCover: FullScreenCover? { get set }
    
    /// Builds the view for the specified full screen cover.
    /// - Parameter fullScreenCover: The full screen cover to build the view for.
    /// - Returns: A view representing the full screen cover content.
    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: FullScreenCover) -> FullScreenCoverContent
    
    /// Called after the full screen cover is fully dismissed.
    /// Override this method to perform actions that depend on the cover being completely closed.
    func onFullScreenCoverDismiss()
}

// MARK: - Default Implementation

public extension FullScreenCoverCoordinator {
    /// Default empty implementation - override if needed.
    func onFullScreenCoverDismiss() {}
}

// MARK: - Default FullScreenCover Actions

public extension FullScreenCoverCoordinator {
    /// Presents a full screen cover with the specified content.
    /// - Parameter fullScreenCover: The full screen cover to present.
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    /// Dismisses the currently presented full screen cover.
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
}

