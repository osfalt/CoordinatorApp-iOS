//
//  AuthorizationCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import Combine
import UIKit

// MARK: - AuthorizationInterfaceStateContaining protocol

public protocol AuthorizationInterfaceStateContaining: AnyObject {
    var state: AuthorizationCoordinator.InterfaceState { get }
}

// MARK: - RedFlowCoordinator

public final class AuthorizationCoordinator: Coordinating {

    // MARK: - Types

    public enum InterfaceState: Equatable {
        case signIn
        case signUp
    }

    // MARK: - State

    public private(set) var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            print("Authorization didSet state = \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }

    // MARK: - Public

    public var onFinish: (() -> Void)?
    public var animationEnabled: Bool = true

    // MARK: - Private

    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private let flowFactory: AuthorizationFlowFactoryProtocol
    private weak var flowNavigationController: BaseNavigationController?
    private weak var signInViewController: UIViewController?
    private weak var signUpViewController: UIViewController?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(flowNavigationController: BaseNavigationController, flowFactory: AuthorizationFlowFactoryProtocol) {
        self.flowNavigationController = flowNavigationController
        self.flowFactory = flowFactory
    }

    public func start() {
        state = .signIn
    }

    // MARK: - States

    private func updateUIBasedOnCurrentState() {
        switch state {
        case .signIn:
            showSignInScreen()

        case .signUp:
            showSignUpScreen()

        case .none:
            break
        }
    }

    private func updateCurrentStateBasedOnUI() {
        guard let flowNavigationController = flowNavigationController else {
            assertionFailure("Invalid UI state")
            return
        }
        guard let authorizationFlowState = (flowNavigationController.topViewController as? AuthorizationInterfaceStateContaining)?.state else {
            assertionFailure("Can't cast to AuthorizationFlowInterfaceStateContaining")
            return
        }
        state = authorizationFlowState
    }

    // MARK: - Show Screens

    private func showSignInScreen() {
        guard signInViewController == nil else {
            return
        }

        let (signInVC, signInModuleOutput) = flowFactory.makeSignInModule()
        signInModuleOutput.didTapSignInButtonPublisher
            .sink { [weak self] in
                self?.onFinish?()
            }
            .store(in: &cancellables)

        flowNavigationController?.pushViewController(signInVC, animated: false)
        self.signInViewController = signInVC
    }

    private func showSignUpScreen() {
        guard signUpViewController == nil else {
            return
        }

        let (signUpVC, signUpModuleOutput) = flowFactory.makeSignUpModule()
//        redSecondModuleOutput.didTapNextButtonPublisher
//            .sink { [weak self] in
//                self?.state = .redDynamicInfoScreen
//            }
//            .store(in: &cancellables)

        flowNavigationController?.pushViewController(signUpVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak signUpVC] popped, shown in
                guard popped === signUpVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.signUpViewController = signUpVC
    }

}

// MARK: - DeepLinkHandling

extension AuthorizationCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        return false
    }

}
