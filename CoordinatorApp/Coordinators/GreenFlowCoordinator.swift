//
//  GreenFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/08/2021.
//

import Combine
import UIKit

// MARK: - DeepLinkPayload

struct GreenFlowDeepLinkPayload: DeepLinkPayload {
   let dynamicText: String
}

// MARK: - GreenFlowInterfaceStateContaining protocol

protocol GreenFlowInterfaceStateContaining: AnyObject {
    var state: GreenFlowCoordinator.InterfaceState { get }
}

// MARK: - GreenFlowCoordinator

public final class GreenFlowCoordinator: DeepLinkHandling {

    // MARK: - Types

    public enum InterfaceState: Equatable, StateTransitioning {
        case greenFirstScreen
        case greenSecondScreen
        case greenThirdScreen(DeepLinkPayload?)

        public static func isValidTransition(from: InterfaceState?, to: InterfaceState?) -> Bool {
            switch (from, to) {
            case (.none, .greenFirstScreen),
                 (.greenFirstScreen, .greenSecondScreen),
                 (.greenSecondScreen, .greenThirdScreen),
                 (.greenThirdScreen, .greenSecondScreen),
                 (.greenThirdScreen, .greenFirstScreen),
                 (.greenSecondScreen, .greenFirstScreen):
                return true
            default:
                return false
            }
        }

        public static func == (lhs: InterfaceState, rhs: InterfaceState) -> Bool {
            switch (lhs, rhs) {
            case (.greenFirstScreen, .greenFirstScreen),
                 (.greenSecondScreen, .greenSecondScreen),
                 (.greenThirdScreen, .greenThirdScreen):
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
            print("GreenFlow - didSet state: \(String(describing: state))")
            updateUIBasedOnCurrentState()
        }
    }
    private var previousState: InterfaceState?

    public var animationEnabled: Bool = true
    private var animated: Bool {
        animationEnabled && !UIAccessibility.isReduceMotionEnabled
    }

    private weak var flowNavigationController: BaseNavigationController?
    #warning("Use array of weak references")
    private weak var firstViewController: UIViewController?
    private weak var secondViewController: UIViewController?
    private weak var thirdViewController: UIViewController?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    public init(flowNavigationController: BaseNavigationController) {
        self.flowNavigationController = flowNavigationController
    }

    // MARK: - Methods

    public func start() {
        state = .greenFirstScreen
    }

    private func updateUIBasedOnCurrentState() {
        guard InterfaceState.isValidTransition(from: previousState, to: state) else {
            #warning("Should this be removed?")
            updateCurrentStateBasedOnUI()
            return
        }

        switch state {
        case .greenFirstScreen:
            if flowNavigationController?.topViewController != nil
                && flowNavigationController?.topViewController != firstViewController
            {
                flowNavigationController?.popToRootViewController(animated: animated)
            }
            showGreenFirstScreen()

        case .greenSecondScreen:
            if flowNavigationController?.topViewController == thirdViewController {
                flowNavigationController?.popViewController(animated: animated)
            }
            showGreenSecondScreen()

        case .greenThirdScreen:
            showGreenThirdScreen()

        case .none:
            break
        }
    }

    private func updateCurrentStateBasedOnUI() {
        guard let flowNavigationController = flowNavigationController else {
            assertionFailure("Invalid UI state")
            return
        }
        guard let greenFlowState = (flowNavigationController.topViewController as? GreenFlowInterfaceStateContaining)?.state else {
            assertionFailure("Can't cast to GreenFlowInterfaceStateContaining")
            return
        }
        state = greenFlowState
    }

    // MARK: - Show Screens

    private func showGreenFirstScreen() {
        guard firstViewController == nil else {
            return
        }

        let greenFirstVC = GreenFlow.makeFirstViewController(didTapNextButton: { [weak self] in
            self?.state = .greenSecondScreen
        })
        flowNavigationController?.pushViewController(greenFirstVC, animated: false)

        self.firstViewController = greenFirstVC
    }

    private func showGreenSecondScreen() {
        guard secondViewController == nil else {
            return
        }

        let greenSecondVC = GreenFlow.makeSecondViewController(didTapNextButton: { [weak self] in
            self?.state = .greenThirdScreen(nil)
        })
        flowNavigationController?.pushViewController(greenSecondVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak greenSecondVC] popped, shown in
                guard popped === greenSecondVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.secondViewController = greenSecondVC
    }

    private func showGreenThirdScreen(dynamicText: String? = nil) {
        guard thirdViewController == nil else {
            return
        }

        let greenThirdVC = GreenFlow.makeThirdViewController(dynamicText: dynamicText, didTapNextButton: {})
        flowNavigationController?.pushViewController(greenThirdVC, animated: animated)
        flowNavigationController?.didPopViewControllerPublisher
            .sink { [weak self, weak greenThirdVC] popped, shown in
                guard popped === greenThirdVC else { return }
                self?.updateCurrentStateBasedOnUI()
            }
            .store(in: &cancellables)

        self.thirdViewController = greenThirdVC
    }

}

// MARK: - DeepLinkHandling

extension GreenFlowCoordinator {

    @discardableResult
    public func handleDeepLink(_ deepLink: DeepLink) -> Bool {
        guard case .greenThirdScreen(let payload) = deepLink else {
            return false
        }

        animationEnabled = false
        state = .greenSecondScreen
        state = .greenThirdScreen(payload)
        animationEnabled = true

        return true
    }

}

// MARK: - Private extensions

extension GreenFlowCoordinator.InterfaceState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .greenFirstScreen:
            return "greenFirstScreen"

        case .greenSecondScreen:
            return "greenSecondScreen"

        case .greenThirdScreen:
            return "greenThirdScreen"
        }
    }

}