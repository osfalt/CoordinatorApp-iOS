//
//  RedFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 25/09/2021.
//

import UIKit

public protocol RedFlowFactoryProtocol {

    typealias RedFlow = (flowController: BaseNavigationController, coordinator: Coordinating)

    typealias RedFirstModule = (controller: UIViewController & RedFlowInterfaceStateContaining, output: RedFirstModuleOutput)
    typealias RedSecondModule = (controller: UIViewController & RedFlowInterfaceStateContaining, output: RedSecondModuleOutput)
    typealias RedDynamicModule = (controller: UIViewController & RedFlowInterfaceStateContaining, output: RedDynamicInfoModuleOutput)

    func makeFlow() -> RedFlow
    func makeRedFirstModule() -> RedFirstModule
    func makeRedSecondModule() -> RedSecondModule
    func makeRedDynamicModule() -> RedDynamicModule

}

final class RedFlowFactory: RedFlowFactoryProtocol {

    func makeFlow() -> RedFlow {
        let redFlowBarItem = UITabBarItem(title: "Red Flow", image: .init(systemName: "house.circle.fill"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        let coordinator = RedFlowCoordinator(flowNavigationController: redFlowNavigationVC, flowFactory: self)
        return (redFlowNavigationVC, coordinator)
    }

    func makeRedFirstModule() -> RedFirstModule {
        let viewModel = RedFirstViewModel()
        let viewController = RedFirstViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeRedSecondModule() -> RedSecondModule {
        let viewModel = RedSecondViewModel()
        let viewController = RedSecondViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeRedDynamicModule() -> RedDynamicModule {
        let viewModel = RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher())
        let viewController = RedDynamicInfoViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
}
