//
//  AuthorizationFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import UIKit

public protocol AuthorizationFlowFactoryProtocol {

    typealias AuthorizationFlow = (flowController: BaseNavigationController, coordinator: Coordinating)

    typealias SignInModule = (controller: UIViewController & AuthorizationInterfaceStateContaining, output: SignInModuleOutput)
    typealias SignUpModule = (controller: UIViewController & AuthorizationInterfaceStateContaining, output: SignUpModuleOutput)

    func makeFlow() -> AuthorizationFlow
    func makeSignInModule() -> SignInModule
    func makeSignUpModule() -> SignUpModule

}

final class AuthorizationFlowFactory: AuthorizationFlowFactoryProtocol {

    func makeFlow() -> AuthorizationFlow {
        let navigationVC = BaseNavigationController()
        let coordinator = AuthorizationCoordinator(flowNavigationController: navigationVC, flowFactory: self)
        return (navigationVC, coordinator)
    }

    func makeSignInModule() -> SignInModule {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeSignUpModule() -> SignUpModule {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

}
