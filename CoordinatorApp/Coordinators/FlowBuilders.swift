//
//  FlowBuilders.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import UIKit

final class RedFlow {

    static func makeFlowNavigationController() -> BaseNavigationController {
        let redFlowBarItem = UITabBarItem(title: "Red Flow", image: .init(systemName: "person.crop.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        return redFlowNavigationVC
    }

    static func makeFirstViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = RedFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedFirstViewController(viewModel: viewModel)
        return viewController
    }

    static func makeSecondViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = RedSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = RedSecondViewController(viewModel: viewModel)
        return viewController
    }
    
    static func makeRedDynamicInfoViewController() -> UIViewController {
        let viewModel = RedDynamicInfoViewModel()
        let viewController = RedDynamicInfoViewController(viewModel: viewModel)
        return viewController
    }

}

final class GreenFlow {

    static func makeFlowNavigationController() -> BaseNavigationController {
        let redFlowBarItem = UITabBarItem(title: "Green Flow", image: .init(systemName: "person.2.circle"), selectedImage: nil)
        let redFlowNavigationVC = BaseNavigationController()
        redFlowNavigationVC.tabBarItem = redFlowBarItem
        return redFlowNavigationVC
    }

    static func makeFirstViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = GreenFirstViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenFirstViewController(viewModel: viewModel)
        return viewController
    }

    static func makeSecondViewController(didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = GreenSecondViewModel(didTapNextButton: didTapNextButton)
        let viewController = GreenSecondViewController(viewModel: viewModel)
        return viewController
    }

    static func makeThirdViewController(dynamicText: String? = nil, didTapNextButton: @escaping () -> Void) -> UIViewController {
        let viewModel = GreenThirdViewModel(dynamicText: dynamicText, didTapNextButton: didTapNextButton)
        let viewController = GreenThirdViewController(viewModel: viewModel)
        return viewController
    }

}
