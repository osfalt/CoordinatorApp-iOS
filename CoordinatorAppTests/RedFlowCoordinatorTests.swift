//
//  RedFlowCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 08/08/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class RedFlowCoordinatorTests: XCTestCase {

    private var flowNavigationController: BaseNavigationController!
    private var coordinator: RedFlowCoordinator!

    override func setUpWithError() throws {
        flowNavigationController = BaseNavigationController()
        coordinator = RedFlowCoordinator(flowNavigationController: flowNavigationController, builder: RedFlowBuilder())
        coordinator.animationEnabled = false
    }

    // MARK: - Basic Tests
    func testStart() throws {
        coordinator.start()
        assertBasics()
    }

    // MARK: - Transitions Tests
    func testInterfaceStateTransitionsValidity() throws {
        typealias State = RedFlowCoordinator.InterfaceState

        XCTAssertTrue(State.isValidTransition(from: .none, to: .redFirstScreen))
        XCTAssertTrue(State.isValidTransition(from: .redFirstScreen, to: .redSecondScreen))
        XCTAssertTrue(State.isValidTransition(from: .redSecondScreen, to: .redFirstScreen))

        XCTAssertFalse(State.isValidTransition(from: .none, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .none, to: .redSecondScreen))
        XCTAssertFalse(State.isValidTransition(from: .redFirstScreen, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .redFirstScreen, to: .redFirstScreen))
        XCTAssertFalse(State.isValidTransition(from: .redSecondScreen, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .redSecondScreen, to: .redSecondScreen))
    }

    // MARK: - Flow Tests
    func testSuccessOfRedFlowTransitionFromInitialToFirstScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .redFirstScreen
        assertBasics()
    }

    func testSuccessOfRedFlowTransitionFromFirstToSecondScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .redFirstScreen
        coordinator.state = .redSecondScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 2)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is RedFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is RedSecondViewController)
    }

    func testSuccessOfRedFlowTransitionFromSecondToFirstScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .redFirstScreen
        coordinator.state = .redSecondScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 2)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is RedFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is RedSecondViewController)

        coordinator.state = .redFirstScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is RedFirstViewController)
    }

    // MARK: - Private methods
    private func assertBasics() {
        XCTAssertTrue(flowNavigationController.viewControllers[0] is RedFirstViewController)
    }

}
