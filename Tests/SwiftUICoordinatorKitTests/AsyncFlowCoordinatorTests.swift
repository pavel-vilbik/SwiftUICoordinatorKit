//
//  AsyncFlowCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import Foundation
@testable import SwiftUICoordinatorKit

// MARK: - Mock Flow Result

enum MockFlowResult: Sendable, Equatable {
    case success(String)
    case cancelled
}

// MARK: - Mock Coordinator

@MainActor
final class MockAsyncFlowCoordinator: AsyncFlowCoordinator {
    // MARK: - AsyncFlowCoordinator Requirements
    
    var flowContinuation: CheckedContinuation<MockFlowResult, Never>?
    var pendingFlowResult: MockFlowResult?
    var defaultFlowResult: MockFlowResult { .cancelled }
    
    // MARK: - Call Tracking
    
    var startFlowPresentationCallCount = 0
    var dismissFlowPresentationCallCount = 0
    var resetFlowStateCallCount = 0
    
    // MARK: - Presentation Methods
    
    func startFlowPresentation() {
        startFlowPresentationCallCount += 1
    }
    
    func dismissFlowPresentation() {
        dismissFlowPresentationCallCount += 1
    }
    
    func resetFlowState() {
        resetFlowStateCallCount += 1
    }
}

// MARK: - Run Tests

@Suite("AsyncFlowCoordinator Run Tests")
struct AsyncFlowCoordinatorRunTests {
    
    @MainActor
    @Test("run calls startFlowPresentation")
    func run_callsStartFlowPresentation() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        #expect(coordinator.startFlowPresentationCallCount == 0)
        
        // Start run in a task, then immediately finish to avoid hanging
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for startFlowPresentation to be called
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.startFlowPresentationCallCount == 1)
        
        // Finish the flow to complete the task
        coordinator.onFlowDismiss()
        _ = await task.value
    }
    
    @MainActor
    @Test("run sets flowContinuation")
    func run_setsFlowContinuation() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        #expect(coordinator.flowContinuation == nil)
        
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for continuation to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.flowContinuation != nil)
        
        // Finish the flow to complete the task
        coordinator.onFlowDismiss()
        _ = await task.value
    }
}

// MARK: - FinishFlow Tests

@Suite("AsyncFlowCoordinator FinishFlow Tests")
struct AsyncFlowCoordinatorFinishFlowTests {
    
    @MainActor
    @Test("finishFlow sets pendingFlowResult")
    func finishFlow_setsPendingFlowResult() {
        let coordinator = MockAsyncFlowCoordinator()
        
        #expect(coordinator.pendingFlowResult == nil)
        
        coordinator.finishFlow(with: .success("Test"))
        
        #expect(coordinator.pendingFlowResult == .success("Test"))
    }
    
    @MainActor
    @Test("finishFlow calls dismissFlowPresentation")
    func finishFlow_callsDismissFlowPresentation() {
        let coordinator = MockAsyncFlowCoordinator()
        
        #expect(coordinator.dismissFlowPresentationCallCount == 0)
        
        coordinator.finishFlow(with: .success("Test"))
        
        #expect(coordinator.dismissFlowPresentationCallCount == 1)
    }
}

// MARK: - OnFlowDismiss Tests

@Suite("AsyncFlowCoordinator OnFlowDismiss Tests")
struct AsyncFlowCoordinatorOnFlowDismissTests {
    
    @MainActor
    @Test("onFlowDismiss returns pending result")
    func onFlowDismiss_returnsPendingResult() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for continuation to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        // Set pending result and dismiss
        coordinator.pendingFlowResult = .success("Expected Result")
        coordinator.onFlowDismiss()
        
        let result = await task.value
        #expect(result == .success("Expected Result"))
    }
    
    @MainActor
    @Test("onFlowDismiss returns default result when no pending result")
    func onFlowDismiss_returnsDefaultResultWhenNoPendingResult() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for continuation to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        // Dismiss without setting pending result (simulates interactive dismiss)
        #expect(coordinator.pendingFlowResult == nil)
        coordinator.onFlowDismiss()
        
        let result = await task.value
        #expect(result == .cancelled) // defaultFlowResult
    }
    
    @MainActor
    @Test("onFlowDismiss clears continuation and pending result")
    func onFlowDismiss_clearsContinuationAndPendingResult() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for continuation to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        coordinator.pendingFlowResult = .success("Test")
        #expect(coordinator.flowContinuation != nil)
        #expect(coordinator.pendingFlowResult != nil)
        
        coordinator.onFlowDismiss()
        _ = await task.value
        
        #expect(coordinator.flowContinuation == nil)
        #expect(coordinator.pendingFlowResult == nil)
    }
    
    @MainActor
    @Test("onFlowDismiss calls resetFlowState")
    func onFlowDismiss_callsResetFlowState() async {
        let coordinator = MockAsyncFlowCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        // Give time for continuation to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.resetFlowStateCallCount == 0)
        
        coordinator.onFlowDismiss()
        _ = await task.value
        
        #expect(coordinator.resetFlowStateCallCount == 1)
    }
}
