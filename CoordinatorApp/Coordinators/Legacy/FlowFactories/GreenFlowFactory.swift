//
//  GreenFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 25/09/2021.
//

import UIKit

public protocol GreenFlowFactoryProtocol {

    typealias GreenFlow = (flowController: BaseNavigationController, coordinator: Coordinating)
    typealias GreenFirstModule = (controller: UIViewController & GreenFlowInterfaceStateContaining, output: GreenFirstModuleOutput)
    typealias GreenSecondModule = (controller: UIViewController & GreenFlowInterfaceStateContaining, output: GreenSecondModuleOutput)
    typealias GreenThirdModule = (controller: UIViewController & GreenFlowInterfaceStateContaining, output: GreenThirdModuleOutput)

    func makeFlow() -> GreenFlow
    func makeGreenFirstModule() -> GreenFirstModule
    func makeGreenSecondModule() -> GreenSecondModule
    func makeGreenThirdModule(dynamicText: String?) -> GreenThirdModule

}

final class GreenFlowFactory: GreenFlowFactoryProtocol {

    func makeFlow() -> GreenFlow {
        let greenFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "book.circle.fill"), selectedImage: nil)
        let greenFlowNavigationVC = BaseNavigationController()
        greenFlowNavigationVC.tabBarItem = greenFlowBarItem
        let coordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, flowFactory: self)
        return (greenFlowNavigationVC, coordinator)
    }

    func makeGreenFirstModule() -> GreenFirstModule {
        let viewModel = GreenFirstViewModel()
        let viewController = GreenFirstViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeGreenSecondModule() -> GreenSecondModule {
        let viewModel = GreenSecondViewModel()
        let viewController = GreenSecondViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeGreenThirdModule(dynamicText: String? = nil) -> GreenThirdModule {
        let viewModel = GreenThirdViewModel(dynamicText: dynamicText)
        let viewController = GreenThirdViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
}
