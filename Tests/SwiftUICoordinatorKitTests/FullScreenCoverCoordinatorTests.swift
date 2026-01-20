//
//  FullScreenCoverCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Full Screen Cover Item

struct MockFullScreenCoverItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

// MARK: - Mock Coordinator

@MainActor
@Observable
final class MockFullScreenCoverCoordinator: FullScreenCoverCoordinator {
    var fullScreenCover: MockFullScreenCoverItem?
    
    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: MockFullScreenCoverItem) -> some View {
        EmptyView()
    }
}

// MARK: - PresentFullScreenCover Tests

@Suite("FullScreenCoverCoordinator PresentFullScreenCover Tests")
struct FullScreenCoverCoordinatorPresentTests {
    
    @MainActor
    @Test("presentFullScreenCover sets fullScreenCover")
    func presentFullScreenCover_setsFullScreenCover() {
        let coordinator = MockFullScreenCoverCoordinator()
        let cover = MockFullScreenCoverItem(title: "Test Cover")
        
        #expect(coordinator.fullScreenCover == nil)
        
        coordinator.presentFullScreenCover(cover)
        
        #expect(coordinator.fullScreenCover != nil)
        #expect(coordinator.fullScreenCover?.title == "Test Cover")
    }
    
    @MainActor
    @Test("presentFullScreenCover replaces existing cover")
    func presentFullScreenCover_replacesExistingCover() {
        let coordinator = MockFullScreenCoverCoordinator()
        let firstCover = MockFullScreenCoverItem(title: "First Cover")
        let secondCover = MockFullScreenCoverItem(title: "Second Cover")
        
        coordinator.presentFullScreenCover(firstCover)
        #expect(coordinator.fullScreenCover?.title == "First Cover")
        
        coordinator.presentFullScreenCover(secondCover)
        #expect(coordinator.fullScreenCover?.title == "Second Cover")
    }
}

// MARK: - DismissFullScreenCover Tests

@Suite("FullScreenCoverCoordinator DismissFullScreenCover Tests")
struct FullScreenCoverCoordinatorDismissTests {
    
    @MainActor
    @Test("dismissFullScreenCover clears fullScreenCover")
    func dismissFullScreenCover_clearsFullScreenCover() {
        let coordinator = MockFullScreenCoverCoordinator()
        let cover = MockFullScreenCoverItem(title: "Test Cover")
        
        coordinator.presentFullScreenCover(cover)
        #expect(coordinator.fullScreenCover != nil)
        
        coordinator.dismissFullScreenCover()
        #expect(coordinator.fullScreenCover == nil)
    }
    
    @MainActor
    @Test("dismissFullScreenCover on nil cover does not crash")
    func dismissFullScreenCover_onNilCover_doesNotCrash() {
        let coordinator = MockFullScreenCoverCoordinator()
        
        #expect(coordinator.fullScreenCover == nil)
        
        coordinator.dismissFullScreenCover()
        
        #expect(coordinator.fullScreenCover == nil)
    }
}

// MARK: - OnFullScreenCoverDismiss Tests

@Suite("FullScreenCoverCoordinator OnDismiss Tests")
struct FullScreenCoverCoordinatorOnDismissTests {
    
    @MainActor
    @Test("onFullScreenCoverDismiss default implementation does not crash")
    func onFullScreenCoverDismiss_defaultImplementation_doesNotCrash() {
        let coordinator = MockFullScreenCoverCoordinator()
        
        // Call default implementation - should not crash
        coordinator.onFullScreenCoverDismiss()
        
        // If we reach here, the test passes
        #expect(true)
    }
}
