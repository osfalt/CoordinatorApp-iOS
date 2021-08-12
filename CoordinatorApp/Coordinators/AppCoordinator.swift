//
//  AppCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import Combine
import UIKit

// MARK: - StateTransitioning protocol
public protocol StateTransitioning {
    associatedtype State: Equatable
    static func isValidTransition(from: State, to: State) -> Bool
}

// MARK: - AppCoordinator
public final class AppCoordinator: NSObject, UITabBarControllerDelegate, DeepLinkHandling {

    // MARK: - Public
    public enum TabIndex {
        public static let redFlow = 0
        public static let greenFlow = 1
    }

    public enum InterfaceState: Equatable, StateTransitioning {
        case redFlow
        case greenFlow

        public static func isValidTransition(from: InterfaceState?, to: InterfaceState?) -> Bool {
            switch (from, to) {
            case (.none, .redFlow),
                 (.none, .greenFlow),
                 (.redFlow, .greenFlow),
                 (.greenFlow, .redFlow),
                 (.redFlow, .redFlow),
                 (.greenFlow, .greenFlow):
                return true
            default:
                return false
            }
        }
    }

    // MARK: - States
    public private(set) var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            previousState = oldValue
            print("App didSet state = \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }
    private var previousState: InterfaceState?

    public var animationEnabled: Bool = true

    // MARK: - Private
    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private let builder: FlowsBuilderProtocol
    private weak var rootViewController: UIViewController?
    private weak var tabBarController: UITabBarController?

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

        redFlowCoordinator = RedFlowCoordinator(flowNavigationController: redFlowNavigationController, builder: builder.redFlow)
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
        guard InterfaceState.isValidTransition(from: previousState, to: state) else {
            updateCurrentStateBasedOnUI()
            return
        }

        switch state {
        case .redFlow:
            guard tabBarController?.selectedIndex != TabIndex.redFlow else {
                return
            }
            tabBarController?.selectedIndex = TabIndex.redFlow
            updateCurrentSelectedTabIndex()

        case .greenFlow:
            guard tabBarController?.selectedIndex != TabIndex.greenFlow else {
                return
            }
            tabBarController?.selectedIndex = TabIndex.greenFlow
            updateCurrentSelectedTabIndex()

        case .none:
            break
        }
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

    private func updateCurrentSelectedTabIndex() {
        currentSelectedTabIndex = tabBarController?.selectedIndex
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

        updateCurrentSelectedTabIndex()
    }

}

// MARK: - UITabBarControllerDelegate

extension AppCoordinator {

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if currentSelectedTabIndex == tabBarController.selectedIndex {
            return
        }
        updateCurrentSelectedTabIndex()
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
