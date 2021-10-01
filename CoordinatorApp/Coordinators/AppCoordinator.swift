//
//  AppCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 01/10/2021.
//

import Combine
import UIKit

public final class AppCoordinator: Coordinating {

    // MARK: - Types

    public enum InterfaceState: Equatable {
        case authorization
        case mainFlow
    }

    // MARK: - State

    public private(set) var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            print("AppCoordinator didSet state = \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }

    // MARK: - Properties

    public var onFinish: (() -> Void)?
    public var animationEnabled: Bool = true {
        didSet { updateAnimatedValue() }
    }
    private var animated: Bool = true

    private let flowFactory: AppFlowFactoryProtocol
    private weak var rootViewController: UIViewController?
    private var childCoordinators: [Coordinating] = []

    // MARK: - Init

    public init(rootViewController: UIViewController, flowFactory: AppFlowFactoryProtocol) {
        self.rootViewController = rootViewController
        self.flowFactory = flowFactory
        updateAnimatedValue()
    }

    public func start() {
        #warning("Store and read the flag from storage")
        let authorized = Bool.random()
        if authorized {
            state = .mainFlow
        } else {
            state = .authorization
        }
    }

    // MARK: - Start Child Coordinators

    private func startAuthorizationFlow() {
        let (authorizationFlowController, authorizationCoordinator) = flowFactory.authorizationFlow.makeFlow()

        authorizationCoordinator.onFinish = { [weak self] in
            #warning("Update state based on 'authorized' flag value")
            self?.state = .mainFlow
        }

        rootViewController?.embed(authorizationFlowController)
        authorizationCoordinator.start()
        childCoordinators.append(authorizationCoordinator)
    }

    private func startMainFlow() {
        let (mainFlowController, mainFlowCoordinator) = flowFactory.mainFlow.makeFlow()
        rootViewController?.embed(mainFlowController)
        mainFlowCoordinator.start()
        childCoordinators.append(mainFlowCoordinator)
    }

    // MARK: - States

    private func updateUIBasedOnCurrentState() {
        switch state {
        case .authorization:
            startAuthorizationFlow()

        case .mainFlow:
            startMainFlow()

        case .none:
            break
        }
    }

    // MARK: - Private methods

    private func updateAnimatedValue() {
        animated = animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

}

// MARK: - DeepLinkHandling

extension AppCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        let deepLinkWasHandled = childCoordinators
            .lazy
            .map { $0.handleDeepLink(deepLink) }
            .first(where: { handled in return handled })

        return deepLinkWasHandled == true
    }

}
