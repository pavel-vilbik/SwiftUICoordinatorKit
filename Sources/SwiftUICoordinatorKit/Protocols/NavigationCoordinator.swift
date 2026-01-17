//
//  NavigationCoordinator.swift
//  SwiftUICoordinatorKit
//

import SwiftUI

// MARK: - NavigationCoordinator

/// Base protocol for coordinators that manage NavigationStack navigation.
/// Use this protocol when you need push/pop navigation within a navigation stack.
@MainActor
public protocol NavigationCoordinator: Observable, AnyObject {
    associatedtype Page: Hashable
    associatedtype Content: View
    
    /// Navigation path for managing the navigation stack state.
    var paths: NavigationPath { get set }
    
    /// The root page of the navigation stack.
    var page: Page { get }
    
    /// Builds the view for the specified page.
    /// - Parameters:
    ///   - page: The page to build the view for.
    ///   - isAnimated: Whether the transition should be animated.
    /// - Returns: A view representing the specified page.
    @ViewBuilder
    func build(_ page: Page, isAnimated: Bool) -> Content
}

// MARK: - Default Navigation Actions

public extension NavigationCoordinator {
    /// Pushes a new page onto the navigation stack.
    /// - Parameter page: The page to push.
    func push(_ page: Page) {
        paths.append(page)
    }
    
    /// Pops the current page from the navigation stack.
    func pop() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }
    
    /// Pops all pages from the navigation stack, returning to the root.
    func popToRoot() {
        guard !paths.isEmpty else { return }
        paths.removeLast(paths.count)
    }
}

