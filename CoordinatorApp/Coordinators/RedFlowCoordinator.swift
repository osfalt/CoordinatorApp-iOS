//
//  RedFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/08/2021.
//

import Combine
import UIKit

// MARK: - RedFlowInterfaceStateContaining protocol

protocol RedFlowInterfaceStateContaining: AnyObject {
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
    public var animationEnabled: Bool = true
    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private let moduleFactory: RedFlowModuleFactoryProtocol
    private weak var flowNavigationController: BaseNavigationController?
    #warning("Use array of weak references")
    private weak var firstViewController: UIViewController?
    private weak var secondViewController: UIViewController?
    private weak var dynamicInfoViewController: UIViewController?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(flowNavigationController: BaseNavigationController, moduleFactory: RedFlowModuleFactoryProtocol) {
        self.flowNavigationController = flowNavigationController
        self.moduleFactory = moduleFactory
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

        let redFirstVC = moduleFactory.makeRedFirstModule(didTapNextButton: { [weak self] in
            self?.state = .redSecondScreen
        }).vc
        flowNavigationController?.pushViewController(redFirstVC, animated: false)

        self.firstViewController = redFirstVC
    }

    private func showRedSecondScreen() {
        guard secondViewController == nil else {
            return
        }

        let redSecondVC = moduleFactory.makeRedSecondModule(didTapNextButton: { [weak self] in
            self?.state = .redDynamicInfoScreen
        }).vc
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

        let dynamicInfoVC = moduleFactory.makeRedDynamicModule().vc
        flowNavigationController?.pushViewController(dynamicInfoVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak dynamicInfoVC] popped, shown in
                guard popped === dynamicInfoVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.dynamicInfoViewController = dynamicInfoVC
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
