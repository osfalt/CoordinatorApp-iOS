//
//  MockAuthorizationFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 28/09/2021.
//

import Combine
import UIKit
@testable import CoordinatorApp

// MARK: - Authorization Flow Factory

final class MockAuthorizationFlowFactory: AuthorizationFlowFactoryProtocol {
    private(set) lazy var flowNavigationRouter = MockNavigationRouter()
    private(set) weak var signInViewController: MockSignInViewController?
    private(set) weak var signUpViewController: MockSignUpViewController?

    weak var coordinator: AuthorizationCoordinator?

    func makeFlow() -> AuthorizationFlow {
        let coordinator = AuthorizationCoordinator(
            flowNavigationRouter: flowNavigationRouter,
            flowFactory: self,
            authorizationTokenStore: AuthorizationTokenStore(store: UserDefaults.standard)
        )
        self.coordinator = coordinator
        return (flowNavigationRouter, coordinator)
    }

    func makeSignInModule() -> SignInModule {
        if let signInViewController = signInViewController {
            return (signInViewController, signInViewController.viewModel)
        }
        let signInViewController = MockSignInViewController()
        self.signInViewController = signInViewController
        return (signInViewController, signInViewController.viewModel)
    }

    func makeSignUpModule() -> SignUpModule {
        if let signUpViewController = signUpViewController {
            return (signUpViewController, signUpViewController.viewModel)
        }
        let signUpViewController = MockSignUpViewController()
        self.signUpViewController = signUpViewController
        return (signUpViewController, signUpViewController.viewModel)
    }
}

// MARK: - Authorization Flow View Controllers

final class MockSignInViewController: UIViewController, AuthorizationInterfaceStateContaining {
    let state: AuthorizationCoordinator.InterfaceState = .signIn

    private(set) lazy var viewModel = SignInViewModel()

    func tapOnSignInButton() {
        viewModel.didTapSignInButton()
    }

    func tapOnCreateAccountButton() {
        viewModel.didTapCreateAccountButton()
    }
}

final class MockSignUpViewController: UIViewController, AuthorizationInterfaceStateContaining {
    let state: AuthorizationCoordinator.InterfaceState = .signUp

    private(set) lazy var viewModel = SignUpViewModel()

    func tapOnSignUpButton() {
        viewModel.didTapSignUpButton()
    }
}
