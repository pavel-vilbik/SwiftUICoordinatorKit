//
//  AsyncFullScreenCoverCoordinator.swift
//  SwiftUICoordinatorKit
//

import Foundation

// MARK: - AsyncFullScreenCoverCoordinator

/// Composite protocol for coordinators that present async flows via full screen cover.
/// Combines AsyncFlowCoordinator with FullScreenCoverCoordinator and provides
/// default implementations for dismissFlowPresentation() and onFullScreenCoverDismiss().
///
/// Usage:
/// ```swift
/// class MyCoordinator: AsyncFullScreenCoverCoordinator {
///     // Storage
///     var flowContinuation: CheckedContinuation<MyResult, Never>?
///     var pendingFlowResult: MyResult?
///     var defaultFlowResult: MyResult { .cancelled }
///
///     // Only need to implement:
///     func startFlowPresentation() { presentFullScreenCover(.myCover) }
///     func resetFlowState() { popToRoot() }
/// }
/// ```
@MainActor
public protocol AsyncFullScreenCoverCoordinator: AsyncFlowCoordinator, FullScreenCoverCoordinator {}

// MARK: - Default Implementation

public extension AsyncFullScreenCoverCoordinator {
    
    /// Default implementation: dismisses the full screen cover.
    func dismissFlowPresentation() {
        fullScreenCover = nil
    }
    
    /// Default implementation: delegates to onFlowDismiss().
    func onFullScreenCoverDismiss() {
        onFlowDismiss()
    }
}

