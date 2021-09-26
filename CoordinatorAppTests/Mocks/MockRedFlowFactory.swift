//
//  MockRedFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/08/2021.
//

import Combine
import UIKit
@testable import CoordinatorApp

// MARK: - Red Flow Factory

final class MockRedFlowFactory: RedFlowFactoryProtocol {
    private(set) lazy var redFlowNavigationVC = BaseNavigationController()
    private(set) var redFirstViewController: MockRedFirstController?
    private(set) var redSecondViewController: MockRedSecondController?
    private(set) var redDynamicController: MockRedDynamicController?

    func makeFlow() -> RedFlow {
        let coordinator = RedFlowCoordinator(flowNavigationController: redFlowNavigationVC, flowFactory: self)
        return (redFlowNavigationVC, coordinator)
    }

    func makeRedFirstModule() -> RedFirstModule {
        if let redFirstViewController = redFirstViewController {
            return  (redFirstViewController, redFirstViewController.viewModel)
        }
        let redFirstViewController = MockRedFirstController()
        self.redFirstViewController = redFirstViewController
        return (redFirstViewController, redFirstViewController.viewModel)
    }

    func makeRedSecondModule() -> RedSecondModule {
        if let redSecondViewController = redSecondViewController {
            return  (redSecondViewController, redSecondViewController.viewModel)
        }
        let redSecondViewController = MockRedSecondController()
        self.redSecondViewController = redSecondViewController
        return (redSecondViewController, redSecondViewController.viewModel)
    }

    func makeRedDynamicModule() -> RedDynamicModule {
        if let redDynamicController = redDynamicController {
            return  (redDynamicController, redDynamicController.viewModel)
        }
        let redDynamicController = MockRedDynamicController()
        self.redDynamicController = redDynamicController
        return (redDynamicController, redDynamicController.viewModel)
    }
}

// MARK: - Red Flow View Controllers

final class MockRedFirstController: UIViewController, RedFlowInterfaceStateContaining {
    let state: RedFlowCoordinator.InterfaceState = .redFirstScreen

    private(set) lazy var viewModel = RedFirstViewModel()

    func tapOnNextButton() {
        viewModel.didTapNextButton()
    }
}

final class MockRedSecondController: UIViewController, RedFlowInterfaceStateContaining {
    let state: RedFlowCoordinator.InterfaceState = .redSecondScreen

    private(set) lazy var viewModel = RedSecondViewModel()

    func tapOnNextButton() {
        viewModel.didTapNextButton()
    }
}

final class MockRedDynamicController: UIViewController, RedFlowInterfaceStateContaining {
    let state: RedFlowCoordinator.InterfaceState = .redDynamicInfoScreen

    final class MockDynamicItemsFetcher: DynamicItemsFetchable {
        var fetchItems: AnyPublisher<[DynamicInfoItem], Error> {
            Empty<[DynamicInfoItem], Error>().eraseToAnyPublisher()
        }
    }

    private(set) lazy var viewModel = RedDynamicInfoViewModel(fetcher: MockDynamicItemsFetcher())
}
