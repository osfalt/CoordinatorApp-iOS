//
//  GreenFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 25/09/2021.
//

import UIKit

public protocol GreenFlowFactoryProtocol {

    typealias GreenFlow = (flowController: BaseNavigationController, coordinator: Coordinating)
    typealias GreenFirstModule = (vc: UIViewController & GreenFlowInterfaceStateContaining, vm: GreenFirstViewModel)
    typealias GreenSecondModule = (vc: UIViewController & GreenFlowInterfaceStateContaining, vm: GreenSecondViewModel)
    typealias GreenThirdModule = (vc: UIViewController & GreenFlowInterfaceStateContaining, vm: GreenThirdViewModel)

    func makeFlow() -> GreenFlow
    func makeGreenFirstModule(didTapNextButton: @escaping () -> Void) -> GreenFirstModule
    func makeGreenSecondModule(didTapNextButton: @escaping () -> Void) -> GreenSecondModule
    func makeGreenThirdModule(dynamicText: String?, didTapNextButton: @escaping () -> Void) -> GreenThirdModule

}

final class GreenFlowFactory: GreenFlowFactoryProtocol {

    func makeFlow() -> GreenFlow {
        let greenFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "book.circle.fill"), selectedImage: nil)
        let greenFlowNavigationVC = BaseNavigationController()
        greenFlowNavigationVC.tabBarItem = greenFlowBarItem
        let coordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, flowFactory: self)
        return (greenFlowNavigationVC, coordinator)
    }

    func makeGreenFirstModule(didTapNextButton: @escaping () -> Void) -> GreenFirstModule {
        let viewModel = GreenFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenFirstViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeGreenSecondModule(didTapNextButton: @escaping () -> Void) -> GreenSecondModule {
        let viewModel = GreenSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenSecondViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func makeGreenThirdModule(dynamicText: String? = nil, didTapNextButton: @escaping () -> Void) -> GreenThirdModule {
        let viewModel = GreenThirdViewModel(dynamicText: dynamicText, didTapNextButton: didTapNextButton)
        let viewController = GreenThirdViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
}
