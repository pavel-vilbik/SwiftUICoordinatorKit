//
//  AsyncSheetCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Types

struct MockAsyncSheetItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

enum MockAsyncSheetResult: Sendable, Equatable {
    case success(String)
    case cancelled
}

// MARK: - Mock Coordinator

@MainActor
@Observable
final class MockAsyncSheetCoordinator: AsyncSheetCoordinator {
    // MARK: - SheetCoordinator Requirements
    
    var sheet: MockAsyncSheetItem?
    
    @ViewBuilder
    func buildSheet(_ sheet: MockAsyncSheetItem) -> some View {
        EmptyView()
    }
    
    // MARK: - AsyncFlowCoordinator Requirements
    
    var flowContinuation: CheckedContinuation<MockAsyncSheetResult, Never>?
    var pendingFlowResult: MockAsyncSheetResult?
    var defaultFlowResult: MockAsyncSheetResult { .cancelled }
    
    // MARK: - Call Tracking
    
    var startFlowPresentationCallCount = 0
    var resetFlowStateCallCount = 0
    
    // MARK: - Required Methods
    
    func startFlowPresentation() {
        startFlowPresentationCallCount += 1
        sheet = MockAsyncSheetItem(title: "Flow Sheet")
    }
    
    func resetFlowState() {
        resetFlowStateCallCount += 1
    }
}

// MARK: - DismissFlowPresentation Tests

@Suite("AsyncSheetCoordinator DismissFlowPresentation Tests")
struct AsyncSheetCoordinatorDismissFlowPresentationTests {
    
    @MainActor
    @Test("dismissFlowPresentation clears sheet")
    func dismissFlowPresentation_clearsSheet() {
        let coordinator = MockAsyncSheetCoordinator()
        coordinator.sheet = MockAsyncSheetItem(title: "Test")
        
        #expect(coordinator.sheet != nil)
        
        coordinator.dismissFlowPresentation()
        
        #expect(coordinator.sheet == nil)
    }
}

// MARK: - OnSheetDismiss Tests

@Suite("AsyncSheetCoordinator OnSheetDismiss Tests")
struct AsyncSheetCoordinatorOnSheetDismissTests {
    
    @MainActor
    @Test("onSheetDismiss resumes continuation with pending result")
    func onSheetDismiss_resumesContinuationWithPendingResult() async {
        let coordinator = MockAsyncSheetCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        coordinator.pendingFlowResult = .success("Expected")
        coordinator.onSheetDismiss()
        
        let result = await task.value
        #expect(result == .success("Expected"))
    }
    
    @MainActor
    @Test("onSheetDismiss returns default result when no pending result")
    func onSheetDismiss_returnsDefaultResultWhenNoPendingResult() async {
        let coordinator = MockAsyncSheetCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.pendingFlowResult == nil)
        coordinator.onSheetDismiss()
        
        let result = await task.value
        #expect(result == .cancelled)
    }
    
    @MainActor
    @Test("onSheetDismiss calls resetFlowState")
    func onSheetDismiss_callsResetFlowState() async {
        let coordinator = MockAsyncSheetCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        #expect(coordinator.resetFlowStateCallCount == 0)
        
        coordinator.onSheetDismiss()
        _ = await task.value
        
        #expect(coordinator.resetFlowStateCallCount == 1)
    }
    
    @MainActor
    @Test("onSheetDismiss clears continuation and pending result")
    func onSheetDismiss_clearsContinuationAndPendingResult() async {
        let coordinator = MockAsyncSheetCoordinator()
        
        let task = Task {
            await coordinator.run()
        }
        
        try? await Task.sleep(for: .milliseconds(10))
        
        coordinator.pendingFlowResult = .success("Test")
        #expect(coordinator.flowContinuation != nil)
        #expect(coordinator.pendingFlowResult != nil)
        
        coordinator.onSheetDismiss()
        _ = await task.value
        
        #expect(coordinator.flowContinuation == nil)
        #expect(coordinator.pendingFlowResult == nil)
    }
}
