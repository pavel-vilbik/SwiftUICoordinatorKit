//
//  AlertCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Alert Item

struct MockAlertItem: Identifiable, Equatable {
    let id: UUID
    let message: String
    
    init(message: String) {
        self.id = UUID()
        self.message = message
    }
}

// MARK: - Mock Coordinator

@MainActor
@Observable
final class MockAlertCoordinator: AlertCoordinator {
    var alertItem: MockAlertItem?
    
    func buildAlert(_ alertItem: MockAlertItem) -> Alert {
        Alert(title: Text(alertItem.message))
    }
}

// MARK: - PresentAlert Tests

@Suite("AlertCoordinator PresentAlert Tests")
struct AlertCoordinatorPresentAlertTests {
    
    @MainActor
    @Test("presentAlert sets alertItem")
    func presentAlert_setsAlertItem() {
        let coordinator = MockAlertCoordinator()
        let alertItem = MockAlertItem(message: "Test Alert")
        
        #expect(coordinator.alertItem == nil)
        
        coordinator.presentAlert(alertItem)
        
        #expect(coordinator.alertItem != nil)
        #expect(coordinator.alertItem?.message == "Test Alert")
    }
    
    @MainActor
    @Test("presentAlert replaces existing alert")
    func presentAlert_replacesExistingAlert() {
        let coordinator = MockAlertCoordinator()
        let firstAlert = MockAlertItem(message: "First Alert")
        let secondAlert = MockAlertItem(message: "Second Alert")
        
        coordinator.presentAlert(firstAlert)
        #expect(coordinator.alertItem?.message == "First Alert")
        
        coordinator.presentAlert(secondAlert)
        #expect(coordinator.alertItem?.message == "Second Alert")
    }
}

// MARK: - DismissAlert Tests

@Suite("AlertCoordinator DismissAlert Tests")
struct AlertCoordinatorDismissAlertTests {
    
    @MainActor
    @Test("dismissAlert clears alertItem")
    func dismissAlert_clearsAlertItem() {
        let coordinator = MockAlertCoordinator()
        let alertItem = MockAlertItem(message: "Test Alert")
        
        coordinator.presentAlert(alertItem)
        #expect(coordinator.alertItem != nil)
        
        coordinator.dismissAlert()
        #expect(coordinator.alertItem == nil)
    }
    
    @MainActor
    @Test("dismissAlert on nil alertItem does not crash")
    func dismissAlert_onNilAlertItem_doesNotCrash() {
        let coordinator = MockAlertCoordinator()
        
        #expect(coordinator.alertItem == nil)
        
        coordinator.dismissAlert()
        
        #expect(coordinator.alertItem == nil)
    }
}
