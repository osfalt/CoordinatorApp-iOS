//
//  ModuleFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import UIKit

// MARK: - Module Factory

public protocol MainModuleFactoryProtocol {
    typealias MainFlow = (flowController: UITabBarController, coordinator: Coordinating)
    var redFlow: RedFlowModuleFactoryProtocol { get }
    var greenFlow: GreenFlowModuleFactoryProtocol { get }
    func makeFlow() -> MainFlow
}

final class MainModuleFactory: MainModuleFactoryProtocol {
    let redFlow: RedFlowModuleFactoryProtocol
    let greenFlow: GreenFlowModuleFactoryProtocol

    init(
        redFlow: RedFlowModuleFactoryProtocol = RedFlowModuleFactory(),
        greenFlow: GreenFlowModuleFactoryProtocol = GreenFlowModuleFactory()
    ) {
        self.redFlow = redFlow
        self.greenFlow = greenFlow
    }

    func makeFlow() -> MainFlow {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .lightGray
        let coordinator = MainCoordinator(flowViewController: tabBarController, moduleFactory: self)
        return (tabBarController, coordinator)
    }
}

// MARK: - Red Flow Module Factory

public protocol RedFlowModuleFactoryProtocol {
    typealias RedFlow = (flowController: BaseNavigationController, coordinator: Coordinating)
    typealias RedFirstModule = (vc: UIViewController, vm: RedFirstViewModel)
    typealias RedSecondModule = (vc: UIViewController, vm: RedSecondViewModel)
    typealias RedDynamicModule = (vc: UIViewController, vm: RedDynamicInfoViewModel)

    func makeFlow() -> RedFlow
    func makeRedFirstModule(didTapNextButton: @escaping () -> Void) -> RedFirstModule
    func makeRedSecondModule(didTapNextButton: @escaping () -> Void) -> RedSecondModule
    func makeRedDynamicModule() -> RedDynamicModule
}

final class RedFlowModuleFactory: RedFlowModuleFactoryProtocol {
    func makeFlow() -> RedFlow {
        let redFlowBarItem = UITabBarItem(title: "Red Flow", image: .init(systemName: "person.crop.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        let coordinator = RedFlowCoordinator(flowNavigationController: redFlowNavigationVC, moduleFactory: self)
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

// MARK: - Green Flow Module Factory

public protocol GreenFlowModuleFactoryProtocol {
    typealias GreenFlow = (flowController: BaseNavigationController, coordinator: Coordinating)
    typealias GreenFirstModule = (vc: UIViewController, vm: GreenFirstViewModel)
    typealias GreenSecondModule = (vc: UIViewController, vm: GreenSecondViewModel)
    typealias GreenThirdModule = (vc: UIViewController, vm: GreenThirdViewModel)

    func makeFlow() -> GreenFlow
    func makeGreenFirstModule(didTapNextButton: @escaping () -> Void) -> GreenFirstModule
    func makeGreenSecondModule(didTapNextButton: @escaping () -> Void) -> GreenSecondModule
    func makeGreenThirdModule(dynamicText: String?, didTapNextButton: @escaping () -> Void) -> GreenThirdModule
}

final class GreenFlowModuleFactory: GreenFlowModuleFactoryProtocol {
    func makeFlow() -> GreenFlow {
        let greenFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "person.2.circle"), selectedImage: nil)
        let greenFlowNavigationVC = BaseNavigationController()
        greenFlowNavigationVC.tabBarItem = greenFlowBarItem
        let coordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, moduleFactory: self)
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
