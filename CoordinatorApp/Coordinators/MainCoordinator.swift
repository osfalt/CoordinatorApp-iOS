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

    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private let moduleFactory: MainModuleFactoryProtocol
    private weak var tabBarController: UITabBarController?

    #warning("Should child coordinators be public?")
    private var redFlowCoordinator: Coordinating?
    private var greenFlowCoordinator: Coordinating?

    private var cancellables: Set<AnyCancellable> = []
    private var currentSelectedTabIndex: Int?

    // MARK: - Public
    public init(
        flowViewController: UITabBarController,
        moduleFactory: MainModuleFactoryProtocol
    ) {
        self.tabBarController = flowViewController
        self.moduleFactory = moduleFactory
    }

    public func start() {
        configureTabBarController()
        startRedFlow()
        startGreenFlow()
        state = .redFlow
    }

    // MARK: - Start Child Coordinators

    private func startRedFlow() {
        let (redFlowController, redFlowCoordinator) = moduleFactory.redFlow.makeFlow()
        tabBarController?.addChild(redFlowController)
        redFlowCoordinator.start()
        self.redFlowCoordinator = redFlowCoordinator
    }

    private func startGreenFlow() {
        let (greenFlowNavigationController, greenFlowCoordinator) = moduleFactory.greenFlow.makeFlow()
        tabBarController?.addChild(greenFlowNavigationController)
        greenFlowCoordinator.start()
        self.greenFlowCoordinator = greenFlowCoordinator
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

    // MARK: - Show Screens

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

        return redFlowCoordinator?.handleDeepLink(deepLink) == true
            || greenFlowCoordinator?.handleDeepLink(deepLink) == true
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
