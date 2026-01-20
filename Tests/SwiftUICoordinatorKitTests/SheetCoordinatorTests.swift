//
//  SheetCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Sheet Item

struct MockSheetItem: Identifiable, Equatable {
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
final class MockSheetCoordinator: SheetCoordinator {
    var sheet: MockSheetItem?
    
    @ViewBuilder
    func buildSheet(_ sheet: MockSheetItem) -> some View {
        EmptyView()
    }
}

// MARK: - PresentSheet Tests

@Suite("SheetCoordinator PresentSheet Tests")
struct SheetCoordinatorPresentTests {
    
    @MainActor
    @Test("presentSheet sets sheet")
    func presentSheet_setsSheet() {
        let coordinator = MockSheetCoordinator()
        let sheet = MockSheetItem(title: "Test Sheet")
        
        #expect(coordinator.sheet == nil)
        
        coordinator.presentSheet(sheet)
        
        #expect(coordinator.sheet != nil)
        #expect(coordinator.sheet?.title == "Test Sheet")
    }
    
    @MainActor
    @Test("presentSheet replaces existing sheet")
    func presentSheet_replacesExistingSheet() {
        let coordinator = MockSheetCoordinator()
        let firstSheet = MockSheetItem(title: "First Sheet")
        let secondSheet = MockSheetItem(title: "Second Sheet")
        
        coordinator.presentSheet(firstSheet)
        #expect(coordinator.sheet?.title == "First Sheet")
        
        coordinator.presentSheet(secondSheet)
        #expect(coordinator.sheet?.title == "Second Sheet")
    }
}

// MARK: - DismissSheet Tests

@Suite("SheetCoordinator DismissSheet Tests")
struct SheetCoordinatorDismissTests {
    
    @MainActor
    @Test("dismissSheet clears sheet")
    func dismissSheet_clearsSheet() {
        let coordinator = MockSheetCoordinator()
        let sheet = MockSheetItem(title: "Test Sheet")
        
        coordinator.presentSheet(sheet)
        #expect(coordinator.sheet != nil)
        
        coordinator.dismissSheet()
        #expect(coordinator.sheet == nil)
    }
    
    @MainActor
    @Test("dismissSheet on nil sheet does not crash")
    func dismissSheet_onNilSheet_doesNotCrash() {
        let coordinator = MockSheetCoordinator()
        
        #expect(coordinator.sheet == nil)
        
        coordinator.dismissSheet()
        
        #expect(coordinator.sheet == nil)
    }
}

// MARK: - OnSheetDismiss Tests

@Suite("SheetCoordinator OnDismiss Tests")
struct SheetCoordinatorOnDismissTests {
    
    @MainActor
    @Test("onSheetDismiss default implementation does not crash")
    func onSheetDismiss_defaultImplementation_doesNotCrash() {
        let coordinator = MockSheetCoordinator()
        
        // Call default implementation - should not crash
        coordinator.onSheetDismiss()
        
        // If we reach here, the test passes
        #expect(true)
    }
}
