//
//  NavigationCoordinatorTests.swift
//  SwiftUICoordinatorKitTests
//

import Testing
import SwiftUI
@testable import SwiftUICoordinatorKit

// MARK: - Mock Coordinator

@MainActor
@Observable
final class MockNavigationCoordinator: NavigationCoordinator {
    enum Page: Hashable {
        case home
        case detail
        case settings
    }
    
    var paths = NavigationPath()
    var page: Page = .home
    
    @ViewBuilder
    func build(_ page: Page, isAnimated: Bool) -> some View {
        EmptyView()
    }
}

// MARK: - Push Tests

@Suite("NavigationCoordinator Push Tests")
struct NavigationCoordinatorPushTests {
    
    @MainActor
    @Test("push adds page to path")
    func push_addsPageToPath() {
        let coordinator = MockNavigationCoordinator()
        
        #expect(coordinator.paths.count == 0)
        
        coordinator.push(.detail)
        
        #expect(coordinator.paths.count == 1)
    }
    
    @MainActor
    @Test("push multiple times increases count")
    func push_multipleTimes_increasesCount() {
        let coordinator = MockNavigationCoordinator()
        
        coordinator.push(.detail)
        coordinator.push(.settings)
        coordinator.push(.home)
        
        #expect(coordinator.paths.count == 3)
    }
}

// MARK: - Pop Tests

@Suite("NavigationCoordinator Pop Tests")
struct NavigationCoordinatorPopTests {
    
    @MainActor
    @Test("pop removes last page")
    func pop_removesLastPage() {
        let coordinator = MockNavigationCoordinator()
        coordinator.push(.detail)
        coordinator.push(.settings)
        
        #expect(coordinator.paths.count == 2)
        
        coordinator.pop()
        
        #expect(coordinator.paths.count == 1)
    }
    
    @MainActor
    @Test("pop on empty path does not crash")
    func pop_onEmptyPath_doesNotCrash() {
        let coordinator = MockNavigationCoordinator()
        
        #expect(coordinator.paths.isEmpty)
        
        coordinator.pop()
        
        #expect(coordinator.paths.isEmpty)
    }
}

// MARK: - PopToRoot Tests

@Suite("NavigationCoordinator PopToRoot Tests")
struct NavigationCoordinatorPopToRootTests {
    
    @MainActor
    @Test("popToRoot clears all pages")
    func popToRoot_clearsAllPages() {
        let coordinator = MockNavigationCoordinator()
        coordinator.push(.detail)
        coordinator.push(.settings)
        coordinator.push(.home)
        
        #expect(coordinator.paths.count == 3)
        
        coordinator.popToRoot()
        
        #expect(coordinator.paths.isEmpty)
    }
    
    @MainActor
    @Test("popToRoot on empty path does not crash")
    func popToRoot_onEmptyPath_doesNotCrash() {
        let coordinator = MockNavigationCoordinator()
        
        #expect(coordinator.paths.isEmpty)
        
        coordinator.popToRoot()
        
        #expect(coordinator.paths.isEmpty)
    }
}
