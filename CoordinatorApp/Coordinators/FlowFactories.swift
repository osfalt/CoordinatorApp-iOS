//
//  ModuleFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import UIKit

// MARK: - Main Flow Factory

public protocol MainFlowFactoryProtocol {
    typealias MainFlow = (flowController: UITabBarController, coordinator: Coordinating)
    var redFlow: RedFlowFactoryProtocol { get }
    var greenFlow: GreenFlowFactoryProtocol { get }
    func makeFlow() -> MainFlow
}

final class MainFlowFactory: MainFlowFactoryProtocol {
    let redFlow: RedFlowFactoryProtocol
    let greenFlow: GreenFlowFactoryProtocol

    init(
        redFlow: RedFlowFactoryProtocol = RedFlowFactory(),
        greenFlow: GreenFlowFactoryProtocol = GreenFlowFactory()
    ) {
        self.redFlow = redFlow
        self.greenFlow = greenFlow
    }

    func makeFlow() -> MainFlow {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .lightGray
        let coordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: self)
        return (tabBarController, coordinator)
    }
}

// MARK: - Red Flow Factory

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

// MARK: - Green Flow Factory

public protocol GreenFlowFactoryProtocol {
    typealias GreenFlow = (flowController: BaseNavigationController, coordinator: Coordinating)
    typealias GreenFirstModule = (vc: UIViewController, vm: GreenFirstViewModel)
    typealias GreenSecondModule = (vc: UIViewController, vm: GreenSecondViewModel)
    typealias GreenThirdModule = (vc: UIViewController, vm: GreenThirdViewModel)

    func makeFlow() -> GreenFlow
    func makeGreenFirstModule(didTapNextButton: @escaping () -> Void) -> GreenFirstModule
    func makeGreenSecondModule(didTapNextButton: @escaping () -> Void) -> GreenSecondModule
    func makeGreenThirdModule(dynamicText: String?, didTapNextButton: @escaping () -> Void) -> GreenThirdModule
}

final class GreenFlowFactory: GreenFlowFactoryProtocol {
    func makeFlow() -> GreenFlow {
        let greenFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "person.2.circle"), selectedImage: nil)
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
