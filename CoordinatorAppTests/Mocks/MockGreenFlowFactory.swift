//
//  MockGreenFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 25/09/2021.
//

import Combine
import UIKit
import CoordinatorApp

// MARK: - Green Flow Factory

final class MockGreenFlowFactory: GreenFlowFactoryProtocol {
    private(set) lazy var greenFlowNavigationVC = BaseNavigationController()
    private(set) var greenFirstViewController: MockGreenFirstController?
    private(set) var greenSecondViewController: MockGreenSecondController?
    private(set) var greenThirdViewController: MockGreenThirdController?

    func makeFlow() -> GreenFlow {
        let coordinator = GreenFlowCoordinator(flowNavigationController: greenFlowNavigationVC, flowFactory: self)
        return (greenFlowNavigationVC, coordinator)
    }

    func makeGreenFirstModule(didTapNextButton: @escaping () -> Void) -> GreenFirstModule {
        if let greenFirstViewController = greenFirstViewController {
            return  (greenFirstViewController, greenFirstViewController.viewModel)
        }
        let greenFirstViewController = MockGreenFirstController(didTapNextButton: didTapNextButton)
        self.greenFirstViewController = greenFirstViewController
        return (greenFirstViewController, greenFirstViewController.viewModel)
    }

    func makeGreenSecondModule(didTapNextButton: @escaping () -> Void) -> GreenSecondModule {
        if let greenSecondViewController = greenSecondViewController {
            return  (greenSecondViewController, greenSecondViewController.viewModel)
        }
        let greenSecondViewController = MockGreenSecondController(didTapNextButton: didTapNextButton)
        self.greenSecondViewController = greenSecondViewController
        return (greenSecondViewController, greenSecondViewController.viewModel)
    }

    func makeGreenThirdModule(dynamicText: String?, didTapNextButton: @escaping () -> Void) -> GreenThirdModule {
        if let greenThirdViewController = greenThirdViewController {
            return  (greenThirdViewController, greenThirdViewController.viewModel)
        }
        let greenThirdViewController = MockGreenThirdController(didTapNextButton: didTapNextButton)
        self.greenThirdViewController = greenThirdViewController
        return (greenThirdViewController, greenThirdViewController.viewModel)
    }
}

// MARK: - Green Flow View Controllers

final class MockGreenFirstController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenFirstScreen

    private(set) lazy var viewModel = GreenFirstViewModel(didTapNextButton: didTapNextButton)
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

final class MockGreenSecondController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenSecondScreen

    private(set) lazy var viewModel = GreenSecondViewModel(didTapNextButton: didTapNextButton)
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

final class MockGreenThirdController: UIViewController, GreenFlowInterfaceStateContaining {
    let state: GreenFlowCoordinator.InterfaceState = .greenThirdScreen(nil)

    private(set) lazy var viewModel = GreenThirdViewModel(didTapNextButton: didTapNextButton)
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
