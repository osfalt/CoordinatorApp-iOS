//
//  RedFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/08/2021.
//

import Combine
import UIKit

#warning("TODO: Implement Coordinating protocol")
public protocol Coordinating: AnyObject {
    associatedtype InterfaceState
    var state: InterfaceState? { get }
    var animationEnabled: Bool { get }
    func start()
    func activate() // might be called by parent coordinator to say that child flow is active now (e.g. when user selects a tab in TabBar)
}

// MARK: - RedFlowInterfaceStateContaining protocol

protocol RedFlowInterfaceStateContaining: AnyObject {
    var state: RedFlowCoordinator.InterfaceState { get }
}

// MARK: - RedFlowCoordinator

public final class RedFlowCoordinator: DeepLinkHandling {

    // MARK: - Types

    public enum InterfaceState: Equatable, StateTransitioning {
        case redFirstScreen
        case redSecondScreen
        case redDynamicInfoScreen

        public static func isValidTransition(from: InterfaceState?, to: InterfaceState?) -> Bool {
            switch (from, to) {
            case (.none, .redFirstScreen),
                 (.redFirstScreen, .redSecondScreen),
                 (.redSecondScreen, .redFirstScreen),
                 (.redSecondScreen, .redDynamicInfoScreen),
                 (.redDynamicInfoScreen, .redSecondScreen),
                 (.redDynamicInfoScreen, .redFirstScreen):
                return true
            default:
                return false
            }
        }
    }

    // MARK: - Properties

    public var state: InterfaceState? {
        didSet {
            guard state != oldValue else { return }
            previousState = oldValue
            print("RedFlow - didSet state: \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }
    private var previousState: InterfaceState?

    public var animationEnabled: Bool = true
    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private let builder: RedFlowBuilderProtocol
    private weak var flowNavigationController: BaseNavigationController?
    #warning("Use array of weak references")
    private weak var firstViewController: UIViewController?
    private weak var secondViewController: UIViewController?
    private weak var dynamicInfoViewController: UIViewController?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(flowNavigationController: BaseNavigationController, builder: RedFlowBuilderProtocol) {
        self.flowNavigationController = flowNavigationController
        self.builder = builder
    }

    // MARK: - Methods

    public func start() {
        state = .redFirstScreen
    }

    private func updateUIBasedOnCurrentState() {
        guard InterfaceState.isValidTransition(from: previousState, to: state) else {
            #warning("Should this be removed?")
            updateCurrentStateBasedOnUI()
            return
        }

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

        let redFirstVC = builder.makeRedFirstModule(didTapNextButton: { [weak self] in
            self?.state = .redSecondScreen
        }).vc
        flowNavigationController?.pushViewController(redFirstVC, animated: false)

        self.firstViewController = redFirstVC
    }

    private func showRedSecondScreen() {
        guard secondViewController == nil else {
            return
        }

        let redSecondVC = builder.makeRedSecondModule(didTapNextButton: { [weak self] in
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

        let dynamicInfoVC = builder.makeRedDynamicModule().vc
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
