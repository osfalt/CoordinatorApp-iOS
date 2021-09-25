//
//  RedFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 25/09/2021.
//

import UIKit

public protocol RedFlowFactoryProtocol {

    typealias RedFlow = (flowController: BaseNavigationController, coordinator: Coordinating)

    typealias RedFirstModule = (vc: UIViewController, vm: RedFirstViewModel)
    typealias RedSecondModule = (vc: UIViewController, vm: RedSecondViewModel)
    typealias RedDynamicModule = (vc: UIViewController, vm: RedDynamicInfoViewModel)

    func makeFlow() -> RedFlow
    func makeRedFirstModule(didTapNextButton: @escaping () -> Void) -> RedFirstModule
    func makeRedSecondModule(didTapNextButton: @escaping () -> Void) -> RedSecondModule
    func makeRedDynamicModule() -> RedDynamicModule

}

final class RedFlowFactory: RedFlowFactoryProtocol {

    func makeFlow() -> RedFlow {
        let redFlowBarItem = UITabBarItem(title: "Red Flow", image: .init(systemName: "person.crop.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        let coordinator = RedFlowCoordinator(flowNavigationController: redFlowNavigationVC, flowFactory: self)
        return (redFlowNavigationVC, coordinator)
    }

    func makeRedFirstModule(didTapNextButton: @escaping () -> Void) -> RedFirstModule {
        let viewModel = RedFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedFirstViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeRedSecondModule(didTapNextButton: @escaping () -> Void) -> RedSecondModule {
        let viewModel = RedSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedSecondViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeRedDynamicModule() -> RedDynamicModule {
        let viewModel = RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher())
        let viewController = RedDynamicInfoViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
}
