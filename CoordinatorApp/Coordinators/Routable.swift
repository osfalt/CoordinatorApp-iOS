//
//  Routable.swift
//  CoordinatorApp
//
//  Created by Dre on 08/11/2021.
//

import Combine
import UIKit

// MARK: - Protocols

public protocol Routable: AnyObject {

    func route(to child: Routable)
    func dismiss()

}

public protocol NavigationRoutable: Routable {

    var top: Routable? { get }
    var didPopPublisher: AnyPublisher<(popped: Routable, shown: Routable), Never> { get }

    func push(_ child: Routable)
    func pop()
    func popToRoot()

}

// MARK: - Implementation

extension UIViewController: Routable {

    public func route(to child: Routable) {
        guard let childVC = child as? UIViewController else {
            fatalError("`child` should be an instance of `UIViewController`")
        }
        present(childVC, animated: UIView.areAnimationsEnabled)
    }

    public func dismiss() {
        dismiss(animated: UIView.areAnimationsEnabled)
    }

}

extension BaseNavigationController: NavigationRoutable {

    public var top: Routable? {
        topViewController
    }

    public var didPopPublisher: AnyPublisher<(popped: Routable, shown: Routable), Never> {
        didPopViewControllerPublisher
            .map { controllers -> (popped: Routable, shown: Routable) in
                (popped: controllers.popped, shown: controllers.shown)
            }
            .eraseToAnyPublisher()
    }

    public func push(_ child: Routable) {
        guard let childVC = child as? UIViewController else {
            fatalError("`child` should be an instance of `UIViewController`")
        }
        pushViewController(childVC, animated: UIView.areAnimationsEnabled)
    }

    public func pop() {
        popViewController(animated: UIView.areAnimationsEnabled)
    }

    public func popToRoot() {
        popToRootViewController(animated: UIView.areAnimationsEnabled)
    }

}
