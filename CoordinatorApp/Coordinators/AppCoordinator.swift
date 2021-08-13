//
//  AppCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import Combine
import UIKit

public final class AppCoordinator: NSObject, Coordinating, DeepLinkHandling, UITabBarControllerDelegate {

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

    private let builder: FlowsBuilderProtocol
    private weak var rootViewController: UIViewController?
    private weak var tabBarController: UITabBarController?

    #warning("Should child coordinators be public?")
    private var redFlowCoordinator: RedFlowCoordinator?
    private var greenFlowCoordinator: GreenFlowCoordinator?

    private var cancellables: Set<AnyCancellable> = []
    private var currentSelectedTabIndex: Int?

    // MARK: - Public
    public init(rootViewController: UIViewController, builder: FlowsBuilderProtocol) {
        self.rootViewController = rootViewController
        self.builder = builder
    }

    public func start() {
        embedTabBarScreen()
        startRedFlow()
        startGreenFlow()
        state = .redFlow
    }

    // MARK: - Start Child Coordinators

    private func startRedFlow() {
        let redFlowNavigationController = builder.redFlow.makeFlowViewController()
        tabBarController?.addChild(redFlowNavigationController)

        redFlowCoordinator = RedFlowCoordinator(
            flowNavigationController: redFlowNavigationController,
            builder: builder.redFlow
        )
        redFlowCoordinator?.start()
    }

    private func startGreenFlow() {
        let greenFlowNavigationVC = builder.greenFlow.makeFlowViewController()
        tabBarController?.addChild(greenFlowNavigationVC)

        greenFlowCoordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, builder: builder.greenFlow)
        greenFlowCoordinator?.start()
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

    private func embedTabBarScreen() {
        guard tabBarController == nil else {
            return
        }

        let tabBarController = builder.makeFlowViewController()
        tabBarController.delegate = self
        tabBarController.selectedIndex = TabIndex.redFlow

        rootViewController?.embed(tabBarController)
        self.tabBarController = tabBarController
    }

}

// MARK: - UITabBarControllerDelegate

extension AppCoordinator {

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateCurrentStateBasedOnUI()
    }

}

// MARK: - DeepLinkHandling

extension AppCoordinator {

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

extension AppCoordinator.InterfaceState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .redFlow:
            return "Red Flow"

        case .greenFlow:
            return "Green Flow"
        }
    }

}
