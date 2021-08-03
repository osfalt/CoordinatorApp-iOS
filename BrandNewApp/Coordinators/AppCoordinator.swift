//
//  AppCoordinator.swift
//  BrandNewApp
//
//  Created by Dre on 03/08/2021.
//

import UIKit

#warning("Split into AppCoordinator, RedFlowCoordinator and GreenFlowCoordinator")
public final class AppCoordinator: NSObject, UITabBarControllerDelegate {

    // MARK: - Public
    public enum InterfaceState {
        case initial
        case redFirstScreen
        case redSecondScreen
        case greenFirstScreen
        case greenSecondScreen
    }

    public private(set) var state: InterfaceState? {
        didSet {
            print("didSet state = \(String(describing: state))")
            updateInterfaceBasedOnCurrentState()
        }
    }

    public static var animationEnabled: Bool = true

    // MARK: - Private
    private static var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private var redFirstOnNext: (() -> Void)!
    private var redSecondOnNext: (() -> Void)!
    private var greenFirstOnNext: (() -> Void)!
    private var greenSecondOnNext: (() -> Void)!

    private weak var rootViewController: UIViewController?
    private weak var tabBarController: UITabBarController?
    private weak var redFlowNavigationVC: BaseNavigationController?
    private weak var greenFlowNavigationVC: BaseNavigationController?

    #warning("Use array of weak references")
    private weak var redFirstViewController: UIViewController?
    private weak var redSecondViewController: UIViewController?
    private weak var greenFirstViewController: UIViewController?
    private weak var greenSecondViewController: UIViewController?

    // MARK: - Public
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    public func start() {
        state = .initial
    }

    // MARK: - Private
    private func updateInterfaceBasedOnCurrentState() {
        switch state {
        case .initial:
            embedTabBarScreen()

        case .redFirstScreen:
            showRedFirstScreen()

        case .redSecondScreen:
            showRedSecondScreen()

        case .greenFirstScreen:
            showGreenFirstScreen()

        case .greenSecondScreen:
            showGreenSecondScreen()

        case .none:
            break
        }
    }

    private func embedTabBarScreen() {
        if tabBarController != nil {
            return
        }

        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .lightGray
        tabBarController.delegate = self

        let redFlowNavigationVC = RedFlow.makeFlowNavigationController()
        let greenFlowNavigationVC = GreenFlow.makeFlowNavigationController()

        tabBarController.viewControllers = [
            redFlowNavigationVC,
            greenFlowNavigationVC
        ]

        rootViewController?.embed(tabBarController)

        self.tabBarController = tabBarController
        self.redFlowNavigationVC = redFlowNavigationVC
        self.greenFlowNavigationVC = greenFlowNavigationVC

        state = .redFirstScreen
    }

    private func showRedFirstScreen() {
        if redFirstViewController != nil {
            return
        }

        redFirstOnNext = { [weak self] in
            self?.state = .redSecondScreen
        }

        let redFirstVC = RedFlow.makeFirstViewController(didTapNextButton: redFirstOnNext)
        redFlowNavigationVC?.pushViewController(redFirstVC, animated: false)

        self.redFirstViewController = redFirstVC
    }

    private func showRedSecondScreen() {
        if redSecondViewController != nil {
            return
        }

        redSecondOnNext = {
            print(">>> redSecondOnNext")
        }

        let redSecondVC = RedFlow.makeSecondViewController(didTapNextButton: redSecondOnNext)
        redFlowNavigationVC?.pushViewController(redSecondVC, animated: Self.animated)
        redFlowNavigationVC?.didPopViewController = { [weak self, weak redSecondVC] viewController in
            guard viewController === redSecondVC else { return }
            self?.state = .redFirstScreen
        }

        self.redSecondViewController = redSecondVC
    }

    private func showGreenFirstScreen() {
        if greenFirstViewController != nil {
            return
        }

        greenFirstOnNext = { [weak self] in
            self?.state = .greenSecondScreen
        }

        let greenFirstVC = GreenFlow.makeFirstViewController(didTapNextButton: greenFirstOnNext)
        greenFlowNavigationVC?.pushViewController(greenFirstVC, animated: false)

        self.greenFirstViewController = greenFirstVC
    }

    private func showGreenSecondScreen() {
        if greenSecondViewController != nil {
            return
        }

        greenSecondOnNext = {
            print(">>> greenSecondOnNext")
        }

        let greenSecondVC = GreenFlow.makeSecondViewController(didTapNextButton: greenSecondOnNext)
        greenFlowNavigationVC?.pushViewController(greenSecondVC, animated: Self.animated)
        greenFlowNavigationVC?.didPopViewController = { [weak self, weak greenSecondVC] viewController in
            guard viewController === greenSecondVC else { return }
            self?.state = .greenFirstScreen
        }

        self.greenSecondViewController = greenSecondVC
    }

}

// MARK: - UITabBarControllerDelegate

extension AppCoordinator {

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(">>> didSelect viewController: \(viewController)")
        #warning("TODO: FIX THESE STATES")
        if viewController === redFlowNavigationVC {
            if redFlowNavigationVC?.viewControllers.count == 0 {
                state = .redFirstScreen
            }
        } else if viewController === greenFlowNavigationVC {
            if greenFlowNavigationVC?.viewControllers.count == 0 {
                state = .greenFirstScreen
            }
        }
    }

}

// MARK: - Flow Builders

final class RedFlow {

    static func makeFlowNavigationController() -> BaseNavigationController {
        let redFlowBarItem = UITabBarItem(title: "Red Flow", image: .init(systemName: "person.crop.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        return redFlowNavigationVC
    }

    static func makeFirstViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = RedFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedFirstViewController(viewModel: viewModel)
        return viewController
    }

    static func makeSecondViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = RedSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedSecondViewController(viewModel: viewModel)
        return viewController
    }

}

final class GreenFlow {

    static func makeFlowNavigationController() -> BaseNavigationController {
        let redFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "person.2.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        return redFlowNavigationVC
    }

    static func makeFirstViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = GreenFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenFirstViewController(viewModel: viewModel)
        return viewController
    }

    static func makeSecondViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = GreenSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenSecondViewController(viewModel: viewModel)
        return viewController
    }

}
