//
//  AsyncSheetCoordinator.swift
//  SwiftUICoordinatorKit
//

import Foundation

// MARK: - AsyncSheetCoordinator

/// Composite protocol for coordinators that present async flows via sheet.
/// Combines AsyncFlowCoordinator with SheetCoordinator and provides
/// default implementations for dismissFlowPresentation() and onSheetDismiss().
///
/// Usage:
/// ```swift
/// class MyCoordinator: AsyncSheetCoordinator {
///     // Storage
///     var flowContinuation: CheckedContinuation<MyResult, Never>?
///     var pendingFlowResult: MyResult?
///     var defaultFlowResult: MyResult { .cancelled }
///
///     // Only need to implement:
///     func startFlowPresentation() { presentSheet(.mySheet) }
///     func resetFlowState() { popToRoot() }
/// }
/// ```
@MainActor
public protocol AsyncSheetCoordinator: AsyncFlowCoordinator, SheetCoordinator {}

// MARK: - Default Implementation

public extension AsyncSheetCoordinator {
    
    /// Default implementation: dismisses the sheet.
    func dismissFlowPresentation() {
        sheet = nil
    }
    
    /// Default implementation: delegates to onFlowDismiss().
    func onSheetDismiss() {
        onFlowDismiss()
    }
}

