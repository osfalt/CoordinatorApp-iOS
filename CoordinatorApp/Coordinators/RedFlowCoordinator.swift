//
//  RedFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/08/2021.
//

import Combine
import UIKit

// MARK: - RedFlowInterfaceStateContaining protocol

public protocol RedFlowInterfaceStateContaining: AnyObject {
    var state: RedFlowCoordinator.InterfaceState { get }
}

// MARK: - RedFlowCoordinator

public final class RedFlowCoordinator: Coordinating {

    // MARK: - Types

    public enum InterfaceState: Equatable {
        case redFirstScreen
        case redSecondScreen
        case redDynamicInfoScreen
    }

    // MARK: - Properties

    public private(set) var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            print("RedFlow - didSet state: \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }

    public var onFinish: (() -> Void)?
    public var animationEnabled: Bool = true {
        didSet { updateAnimatedValue() }
    }
    private var animated: Bool = true

    private let flowFactory: RedFlowFactoryProtocol
    private weak var flowNavigationController: BaseNavigationController?
    private weak var firstViewController: UIViewController?
    private weak var secondViewController: UIViewController?
    private weak var dynamicInfoViewController: UIViewController?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(flowNavigationController: BaseNavigationController, flowFactory: RedFlowFactoryProtocol) {
        self.flowNavigationController = flowNavigationController
        self.flowFactory = flowFactory
        updateAnimatedValue()
    }

    // MARK: - Methods

    public func start() {
        state = .redFirstScreen
    }

    private func updateUIBasedOnCurrentState() {
        switch state {
        case .redFirstScreen:
            if flowNavigationController?.topViewController == secondViewController {
                flowNavigationController?.popViewController(animated: animated)
            }
            showRedFirstScreen()

        case .redSecondScreen:
            showRedSecondScreen()

        case .redDynamicInfoScreen:
            showRedDynamicInfoScreen()

        case .none:
            break
        }
    }

    private func updateCurrentStateBasedOnUI() {
        guard let flowNavigationController = flowNavigationController else {
            assertionFailure("Invalid UI state")
            return
        }
        guard let redFlowState = (flowNavigationController.topViewController as? RedFlowInterfaceStateContaining)?.state else {
            assertionFailure("Can't cast to RedFlowInterfaceStateContaining")
            return
        }
        state = redFlowState
    }

    // MARK: - Show Screens

    private func showRedFirstScreen() {
        guard firstViewController == nil else {
            return
        }

        let (redFirstVC, redFirstModuleOutput) = flowFactory.makeRedFirstModule()
        redFirstModuleOutput.didTapNextButtonPublisher
            .sink { [weak self] in
                self?.state = .redSecondScreen
            }
            .store(in: &cancellables)

        flowNavigationController?.pushViewController(redFirstVC, animated: false)

        self.firstViewController = redFirstVC
    }

    private func showRedSecondScreen() {
        guard secondViewController == nil else {
            return
        }

        let (redSecondVC, redSecondModuleOutput) = flowFactory.makeRedSecondModule()
        redSecondModuleOutput.didTapNextButtonPublisher
            .sink { [weak self] in
                self?.state = .redDynamicInfoScreen
            }
            .store(in: &cancellables)

        flowNavigationController?.pushViewController(redSecondVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak redSecondVC] popped, shown in
                guard popped === redSecondVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.secondViewController = redSecondVC
    }

    private func showRedDynamicInfoScreen() {
        guard dynamicInfoViewController == nil else {
            return
        }

        let (dynamicInfoVC, moduleOutput) = flowFactory.makeRedDynamicModule()
        moduleOutput.didSelectItemPublisher
            .sink { item in
                print("didSelectItem: \(item)")
            }
            .store(in: &cancellables)

        flowNavigationController?.pushViewController(dynamicInfoVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak dynamicInfoVC] popped, shown in
                guard popped === dynamicInfoVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.dynamicInfoViewController = dynamicInfoVC
    }

    // MARK: - Private methods

    private func updateAnimatedValue() {
        animated = animationEnabled && !UIAccessibility.isReduceMotionEnabled
        flowNavigationController?.animationEnabled = animated
    }

}

// MARK: - DeepLinkHandling

extension RedFlowCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        return false
    }

}

// MARK: - Private extensions

extension RedFlowCoordinator.InterfaceState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .redFirstScreen:
            return "redFirstScreen"

        case .redSecondScreen:
            return "redSecondScreen"

        case .redDynamicInfoScreen:
            return "redDynamicInfoScreen"
        }
    }

}
