//
//  AppCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 03/08/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

#warning("Add Coordinator tests - check coordinator state when UI changes")

class AppCoordinatorTests: XCTestCase {

    private var rootViewController: UIViewController!
    private var coordinator: AppCoordinator!

    override func setUpWithError() throws {
        rootViewController = UIViewController()
        coordinator = AppCoordinator(rootViewController: rootViewController, builder: FlowsBuilder())
        coordinator.animationEnabled = false
    }

    // MARK: - Basic Tests
    func testStart() throws {
        coordinator.start()
        assertBasics()
    }

    // MARK: - Transitions Tests
    func testInterfaceStateTransitionsValidity() throws {
        typealias State = AppCoordinator.InterfaceState

        XCTAssertTrue(State.isValidTransition(from: .none, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .none, to: .greenFlow))
        XCTAssertTrue(State.isValidTransition(from: .redFlow, to: .greenFlow))
        XCTAssertTrue(State.isValidTransition(from: .redFlow, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .greenFlow, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .greenFlow, to: .greenFlow))

        XCTAssertFalse(State.isValidTransition(from: .none, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .redFlow, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .greenFlow, to: .none))
    }

    // MARK: - Flow Tests
    func testSuccessOfRedFlowScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .redFlow

        let tabBarController = findTabBarController()
        XCTAssertEqual(tabBarController?.selectedIndex, AppCoordinator.TabIndex.redFlow)

        guard let redFlowNavigationController = tabBarController?.viewControllers?[AppCoordinator.TabIndex.redFlow] as? BaseNavigationController else {
            XCTFail("Can't cast to BaseNavigationController")
            return
        }

        XCTAssertEqual(redFlowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(redFlowNavigationController.viewControllers[0] is RedFirstViewController)
    }

    func testSuccessOfGreenFlowScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenFlow

        let tabBarController = findTabBarController()
        XCTAssertEqual(tabBarController?.selectedIndex, AppCoordinator.TabIndex.greenFlow)

        guard let greenFlowNavigationController = tabBarController?.viewControllers?[AppCoordinator.TabIndex.greenFlow] as? BaseNavigationController else {
            XCTFail("Can't cast to BaseNavigationController")
            return
        }

        XCTAssertEqual(greenFlowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(greenFlowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    // MARK: - Private methods
    private func assertBasics() {
        XCTAssertEqual(rootViewController.children.count, 1)
        guard let tabBarController = rootViewController.children[0] as? UITabBarController else {
            XCTFail("Can't cast to UITabBarController")
            return
        }

        XCTAssertEqual(tabBarController.viewControllers?.count, 2)
        XCTAssertEqual(tabBarController.selectedIndex, AppCoordinator.TabIndex.redFlow)

        guard let redFlowNavigationController = tabBarController.viewControllers?[AppCoordinator.TabIndex.redFlow] as? BaseNavigationController else {
            XCTFail("Can't cast to BaseNavigationController")
            return
        }

        guard let greenFlowNavigationController = tabBarController.viewControllers?[AppCoordinator.TabIndex.greenFlow] as? BaseNavigationController else {
            XCTFail("Can't cast to BaseNavigationController")
            return
        }

        XCTAssertEqual(redFlowNavigationController.viewControllers.count, 1)
        XCTAssertEqual(greenFlowNavigationController.viewControllers.count, 1)

        XCTAssertTrue(redFlowNavigationController.viewControllers[0] is RedFirstViewController)
        XCTAssertTrue(greenFlowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    private func findTabBarController() -> UITabBarController? {
        return rootViewController.children[0] as? UITabBarController
    }

}
