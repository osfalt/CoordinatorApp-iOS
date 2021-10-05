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

    // MARK: - Properties

    public var onFinish: (() -> Void)?
    public var animationEnabled: Bool = true {
        didSet { updateAnimatedValue() }
    }
    private var animated: Bool = true

    private let flowFactory: AuthorizationFlowFactoryProtocol
    private weak var flowNavigationController: BaseNavigationController?
    private let authorizationTokenStore: AuthorizationTokenStore
    private weak var signInViewController: UIViewController?
    private weak var signUpViewController: UIViewController?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(
        flowNavigationController: BaseNavigationController,
        flowFactory: AuthorizationFlowFactoryProtocol,
        authorizationTokenStore: AuthorizationTokenStore
    ) {
        self.flowNavigationController = flowNavigationController
        self.flowFactory = flowFactory
        self.authorizationTokenStore = authorizationTokenStore
        updateAnimatedValue()
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
                self?.authorize()
            }
            .store(in: &cancellables)

        signInModuleOutput.didTapCreateAccountButtonPublisher
            .sink { [weak self] in
                self?.state = .signUp
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
        signUpModuleOutput.didTapSignUpButtonPublisher
            .sink { [weak self] in
                self?.authorize()
            }
            .store(in: &cancellables)

        flowNavigationController?.pushViewController(signUpVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak signUpVC] popped, shown in
                guard popped === signUpVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.signUpViewController = signUpVC
    }

    // MARK: - Private methods

    private func authorize() {
        authorizationTokenStore.token = UUID().uuidString
        onFinish?()
    }

    private func updateAnimatedValue() {
        animated = animationEnabled && !UIAccessibility.isReduceMotionEnabled
        flowNavigationController?.animationEnabled = animated
    }

}

// MARK: - DeepLinkHandling

extension AuthorizationCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        return false
    }

}
