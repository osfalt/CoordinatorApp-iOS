//
//  MainCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import Combine
import UIKit

public final class MainCoordinator: NSObject, Coordinating, UITabBarControllerDelegate {

    // MARK: - Public

    public enum TabIndex {
        public static let redFlow = 0
        public static let greenFlow = 1
    }

    public enum InterfaceState: Equatable {
        case redFlow
        case greenFlow
    }

    // MARK: - State

    public private(set) var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            print("App didSet state = \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }

    public var onFinish: (() -> Void)?
    public var animationEnabled: Bool = true

    // MARK: - Private

    private let flowFactory: MainFlowFactoryProtocol
    private weak var tabBarController: UITabBarController?
    private var childCoordinators: [Coordinating] = []

    // MARK: - Public
    public init(flowViewController: UITabBarController, flowFactory: MainFlowFactoryProtocol) {
        self.tabBarController = flowViewController
        self.flowFactory = flowFactory
    }

    public func start() {
        configureTabBarController()
        startRedFlow()
        startGreenFlow()
        state = .redFlow
    }

    // MARK: - Start Child Coordinators

    private func startRedFlow() {
        let (redFlowController, redFlowCoordinator) = flowFactory.redFlow.makeFlow()
        tabBarController?.addChild(redFlowController)
        redFlowCoordinator.start()
        childCoordinators.append(redFlowCoordinator)
    }

    private func startGreenFlow() {
        let (greenFlowNavigationController, greenFlowCoordinator) = flowFactory.greenFlow.makeFlow()
        tabBarController?.addChild(greenFlowNavigationController)
        greenFlowCoordinator.start()
        childCoordinators.append(greenFlowCoordinator)
    }

    // MARK: - States

    private func updateUIBasedOnCurrentState() {
        let selectedIndex: Int
        switch state {
        case .redFlow:
            selectedIndex = TabIndex.redFlow

        case .greenFlow:
            selectedIndex = TabIndex.greenFlow

        case .none:
            return
        }

        if tabBarController?.selectedIndex == selectedIndex {
            return
        }
        tabBarController?.selectedIndex = selectedIndex
    }

    private func updateCurrentStateBasedOnUI() {
        switch tabBarController?.selectedIndex {
        case TabIndex.redFlow:
            state = .redFlow

        case TabIndex.greenFlow:
            state = .greenFlow

        default:
            assertionFailure("Invalid UI state")
            break
        }
    }

    // MARK: - Private methods

    private func configureTabBarController() {
        tabBarController?.delegate = self
        tabBarController?.selectedIndex = TabIndex.redFlow
    }

}

// MARK: - UITabBarControllerDelegate

extension MainCoordinator {

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateCurrentStateBasedOnUI()
    }

}

// MARK: - DeepLinkHandling

extension MainCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        switch deepLink {
        case .greenThirdScreen:
            state = .greenFlow
        }

        let deepLinkWasHandled = childCoordinators
            .lazy
            .map { $0.handleDeepLink(deepLink) }
            .first(where: { handled in return handled })

        return deepLinkWasHandled == true
    }

}

// MARK: - Private extensions

extension MainCoordinator.InterfaceState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .redFlow:
            return "Red Flow"

        case .greenFlow:
            return "Green Flow"
        }
    }

}
