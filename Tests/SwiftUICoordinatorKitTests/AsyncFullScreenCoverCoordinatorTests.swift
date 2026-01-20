//
//  AsyncFullScreenCoverCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Types

struct MockAsyncFullScreenCoverItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

enum MockAsyncFullScreenCoverResult: Sendable, Equatable {
    case success(String)
    case cancelled
}

// MARK: - Mock Coordinator

@MainActor
@Observable
final class MockAsyncFullScreenCoverCoordinator: AsyncFullScreenCoverCoordinator {
    // MARK: - FullScreenCoverCoordinator Requirements
    
    var fullScreenCover: MockAsyncFullScreenCoverItem?
    
    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: MockAsyncFullScreenCoverItem) -> some View {
        EmptyView()
    }
    
    // MARK: - AsyncFlowCoordinator Requirements
    
    var flowContinuation: CheckedContinuation<MockAsyncFullScreenCoverResult, Never>?
    var pendingFlowResult: MockAsyncFullScreenCoverResult?
    var defaultFlowResult: MockAsyncFullScreenCoverResult { .cancelled }
    
    // MARK: - Call Tracking
    
    var startFlowPresentationCallCount = 0
    var resetFlowStateCallCount = 0
    
    // MARK: - Required Methods
    
    func startFlowPresentation() {
        startFlowPresentationCallCount += 1
        fullScreenCover = MockAsyncFullScreenCoverItem(title: "Flow Cover")
    }
    
    func resetFlowState() {
        resetFlowStateCallCount += 1
    }
}

// MARK: - DismissFlowPresentation Tests

@Suite("AsyncFullScreenCoverCoordinator DismissFlowPresentation Tests")
struct AsyncFullScreenCoverCoordinatorDismissFlowPresentationTests {
    
    @MainActor
    @Test("dismissFlowPresentation clears fullScreenCover")
    func dismissFlowPresentation_clearsFullScreenCover() {
        let coordinator = MockAsyncFullScreenCoverCoordinator()
        coordinator.fullScreenCover = MockAsyncFullScreenCoverItem(title: "Test")
        
        #expect(coordinator.fullScreenCover != nil)
        
        coordinator.dismissFlowPresentation()
        
        #expect(coordinator.fullScreenCover == nil)
    }
}

// MARK: - OnFullScreenCoverDismiss Tests

@Suite("AsyncFullScreenCoverCoordinator OnFullScreenCoverDismiss Tests")
struct AsyncFullScreenCoverCoordinatorOnFullScreenCoverDismissTests {
    
    @MainActor
    @Test("onFullScreenCoverDismiss resumes continuation with pending result")
    func onFullScreenCoverDismiss_resumesContinuationWithPendingResult() async {
        let coordinator = MockAsyncFullScreenCoverCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        coordinator.pendingFlowResult = .success("Expected")
        coordinator.onFullScreenCoverDismiss()
        
        let result = await task.value
        #expect(result == .success("Expected"))
    }
    
    @MainActor
    @Test("onFullScreenCoverDismiss returns default result when no pending result")
    func onFullScreenCoverDismiss_returnsDefaultResultWhenNoPendingResult() async {
        let coordinator = MockAsyncFullScreenCoverCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.pendingFlowResult == nil)
        coordinator.onFullScreenCoverDismiss()
        
        let result = await task.value
        #expect(result == .cancelled)
    }
    
    @MainActor
    @Test("onFullScreenCoverDismiss calls resetFlowState")
    func onFullScreenCoverDismiss_callsResetFlowState() async {
        let coordinator = MockAsyncFullScreenCoverCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.resetFlowStateCallCount == 0)
        
        coordinator.onFullScreenCoverDismiss()
        _ = await task.value
        
        #expect(coordinator.resetFlowStateCallCount == 1)
    }
    
    @MainActor
    @Test("onFullScreenCoverDismiss clears continuation and pending result")
    func onFullScreenCoverDismiss_clearsContinuationAndPendingResult() async {
        let coordinator = MockAsyncFullScreenCoverCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        coordinator.pendingFlowResult = .success("Test")
        #expect(coordinator.flowContinuation != nil)
        #expect(coordinator.pendingFlowResult != nil)
        
        coordinator.onFullScreenCoverDismiss()
        _ = await task.value
        
        #expect(coordinator.flowContinuation == nil)
        #expect(coordinator.pendingFlowResult == nil)
    }
}
