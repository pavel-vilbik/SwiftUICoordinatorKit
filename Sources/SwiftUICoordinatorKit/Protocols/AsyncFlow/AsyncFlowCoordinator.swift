//
//  AsyncFlowCoordinator.swift
//  SwiftUICoordinatorKit
//

import Foundation

// MARK: - AsyncFlowCoordinator

/// Protocol for coordinators that manage async flows with a result.
/// Use this protocol when a coordinator needs to be presented modally (sheet, fullScreenCover, etc.)
/// and return a result when the flow completes.
///
/// The coordinator must provide storage for continuation and pending result,
/// as protocols cannot have stored properties.
///
/// Example usage:
/// ```swift
/// class MyCoordinator: AsyncFlowCoordinator {
///     var flowContinuation: CheckedContinuation<MyResult, Never>?
///     var pendingFlowResult: MyResult?
///     var defaultFlowResult: MyResult { .cancelled }
///
///     func startFlowPresentation() { presentSheet(.mySheet) }
///     func dismissFlowPresentation() { sheet = nil }
///     func resetFlowState() { popToRoot() }
/// }
/// ```
@MainActor
public protocol AsyncFlowCoordinator: AnyObject {
    associatedtype FlowResult: Sendable
    
    // MARK: - Storage Requirements
    
    /// Storage for the checked continuation. Coordinator must provide this property.
    var flowContinuation: CheckedContinuation<FlowResult, Never>? { get set }
    
    /// Storage for the pending result before dismiss animation completes.
    var pendingFlowResult: FlowResult? { get set }
    
    // MARK: - Configuration
    
    /// Default result returned when flow is dismissed interactively (e.g., swipe down).
    var defaultFlowResult: FlowResult { get }
    
    // MARK: - Presentation Requirements
    
    /// Called when the flow starts. Implement to show your presentation (sheet, fullScreenCover, etc.).
    func startFlowPresentation()
    
    /// Called when the flow needs to be dismissed. Implement to hide your presentation.
    func dismissFlowPresentation()
    
    /// Called after the flow is fully dismissed. Implement to reset internal state (e.g., popToRoot).
    func resetFlowState()
}

// MARK: - Default Implementation

public extension AsyncFlowCoordinator {
    
    /// Starts the flow and waits for completion.
    /// - Returns: The result of the flow.
    func run() async -> FlowResult {
        startFlowPresentation()
        return await withCheckedContinuation { continuation in
            flowContinuation = continuation
        }
    }
    
    /// Finishes the flow with the specified result.
    /// The result will be returned after the dismiss animation completes.
    /// - Parameter result: The result to return from the flow.
    func finishFlow(with result: FlowResult) {
        pendingFlowResult = result
        dismissFlowPresentation()
    }
    
    /// Called after the presentation is fully dismissed.
    /// Resumes the continuation with the pending result or default result for interactive dismiss.
    func onFlowDismiss() {
        let result = pendingFlowResult ?? defaultFlowResult
        flowContinuation?.resume(returning: result)
        flowContinuation = nil
        pendingFlowResult = nil
        resetFlowState()
    }
}

