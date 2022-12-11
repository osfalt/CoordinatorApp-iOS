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

    private let flowFactory: AuthorizationFlowFactoryProtocol
    private weak var flowNavigationRouter: NavigationRoutable?
    private let authorizationTokenStore: AuthorizationTokenStoring
    private weak var signInViewController: Routable?
    private weak var signUpViewController: Routable?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(
        flowNavigationRouter: NavigationRoutable,
        flowFactory: AuthorizationFlowFactoryProtocol,
        authorizationTokenStore: AuthorizationTokenStoring
    ) {
        self.flowNavigationRouter = flowNavigationRouter
        self.flowFactory = flowFactory
        self.authorizationTokenStore = authorizationTokenStore
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
        guard let flowNavigationRouter = flowNavigationRouter else {
            assertionFailure("Invalid UI state")
            return
        }
        guard let authorizationFlowState = (flowNavigationRouter.top as? AuthorizationInterfaceStateContaining)?.state else {
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

        flowNavigationRouter?.push(signInVC)
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

        flowNavigationRouter?.push(signUpVC)
        flowNavigationRouter?.didPopPublisher
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

}

// MARK: - DeepLinkHandling

extension AuthorizationCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        return false
    }

}
