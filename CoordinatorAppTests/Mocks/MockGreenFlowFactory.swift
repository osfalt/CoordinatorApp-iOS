//
//  MockGreenFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 25/09/2021.
//

import Combine
import UIKit
@testable import CoordinatorApp

// MARK: - Green Flow Factory

final class MockGreenFlowFactory: GreenFlowFactoryProtocol {
    private(set) lazy var greenFlowNavigationVC = BaseNavigationController()
    private(set) var greenFirstViewController: MockGreenFirstController?
    private(set) var greenSecondViewController: MockGreenSecondController?
    private(set) var greenThirdViewController: MockGreenThirdController?

    weak var coordinator: GreenFlowCoordinator?

    func makeFlow() -> GreenFlow {
        let coordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, flowFactory: self)
        self.coordinator = coordinator
        return (greenFlowNavigationVC, coordinator)
    }

    func makeGreenFirstModule() -> GreenFirstModule {
        if let greenFirstViewController = greenFirstViewController {
            return  (greenFirstViewController, greenFirstViewController.viewModel)
        }
        let greenFirstViewController = MockGreenFirstController()
        self.greenFirstViewController = greenFirstViewController
        return (greenFirstViewController, greenFirstViewController.viewModel)
    }

    func makeGreenSecondModule() -> GreenSecondModule {
        if let greenSecondViewController = greenSecondViewController {
            return  (greenSecondViewController, greenSecondViewController.viewModel)
        }
        let greenSecondViewController = MockGreenSecondController()
        self.greenSecondViewController = greenSecondViewController
        return (greenSecondViewController, greenSecondViewController.viewModel)
    }

    func makeGreenThirdModule(dynamicText: String?) -> GreenThirdModule {
        if let greenThirdViewController = greenThirdViewController {
            return  (greenThirdViewController, greenThirdViewController.viewModel)
        }
        let greenThirdViewController = MockGreenThirdController()
        self.greenThirdViewController = greenThirdViewController
        return (greenThirdViewController, greenThirdViewController.viewModel)
    }
}

// MARK: - Green Flow View Controllers

final class MockGreenFirstController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenFirstScreen

    private(set) lazy var viewModel = GreenFirstViewModel()

    func tapOnNextButton() {
        viewModel.didTapNextButton()
    }
}

final class MockGreenSecondController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenSecondScreen

    private(set) lazy var viewModel = GreenSecondViewModel()

    func tapOnNextButton() {
        viewModel.didTapNextButton()
    }
}

final class MockGreenThirdController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenThirdScreen(nil)

    private(set) lazy var viewModel = GreenThirdViewModel()

    func tapOnNextButton() {
        viewModel.didTapNextButton()
    }
}
