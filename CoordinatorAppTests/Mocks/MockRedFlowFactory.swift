//
//  MockRedFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/08/2021.
//

import Combine
import UIKit
import CoordinatorApp

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

    func makeRedFirstModule(didTapNextButton: @escaping () -> Void) -> RedFirstModule {
        if let redFirstViewController = redFirstViewController {
            return  (redFirstViewController, redFirstViewController.viewModel)
        }
        let redFirstViewController = MockRedFirstController(didTapNextButton: didTapNextButton)
        self.redFirstViewController = redFirstViewController
        return (redFirstViewController, redFirstViewController.viewModel)
    }

    func makeRedSecondModule(didTapNextButton: @escaping () -> Void) -> RedSecondModule {
        if let redSecondViewController = redSecondViewController {
            return  (redSecondViewController, redSecondViewController.viewModel)
        }
        let redSecondViewController = MockRedSecondController(didTapNextButton: didTapNextButton)
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

final class MockRedFirstController: UIViewController {
    private(set) lazy var viewModel = RedFirstViewModel(didTapNextButton: didTapNextButton)
    private let didTapNextButton: () -> Void

    init(didTapNextButton: @escaping () -> Void) {
        self.didTapNextButton = didTapNextButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tapOnNextButton() {
        didTapNextButton()
    }
}

final class MockRedSecondController: UIViewController {
    private(set) lazy var viewModel = RedSecondViewModel(didTapNextButton: didTapNextButton)
    private let didTapNextButton: () -> Void

    init(didTapNextButton: @escaping () -> Void) {
        self.didTapNextButton = didTapNextButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tapOnNextButton() {
        didTapNextButton()
    }
}

final class MockRedDynamicController: UIViewController {
    final class MockDynamicItemsFetcher: DynamicItemsFetchable {
        var fetchItems: AnyPublisher<[DynamicInfoItem], Error> {
            Empty<[DynamicInfoItem], Error>().eraseToAnyPublisher()
        }
    }

    private(set) lazy var viewModel = RedDynamicInfoViewModel(fetcher: MockDynamicItemsFetcher())
}
