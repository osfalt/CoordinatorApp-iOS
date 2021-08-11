//
//  GreenFlowCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 08/08/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class GreenFlowCoordinatorTests: XCTestCase {

    private var flowNavigationController: BaseNavigationController!
    private var coordinator: GreenFlowCoordinator!

    override func setUpWithError() throws {
        flowNavigationController = BaseNavigationController()
        coordinator = GreenFlowCoordinator(flowNavigationController: flowNavigationController, builder: GreenFlowBuilder())
        coordinator.animationEnabled = false
    }

    // MARK: - Basic Tests
    func testStart() throws {
        coordinator.start()
        assertBasics()
    }

    // MARK: - Transitions Tests
    func testInterfaceStateTransitionsValidity() throws {
        typealias State = GreenFlowCoordinator.InterfaceState

        XCTAssertTrue(State.isValidTransition(from: .none, to: .greenFirstScreen))
        XCTAssertTrue(State.isValidTransition(from: .greenFirstScreen, to: .greenSecondScreen))
        XCTAssertTrue(State.isValidTransition(from: .greenSecondScreen, to: .greenThirdScreen(nil)))
        XCTAssertTrue(State.isValidTransition(from: .greenSecondScreen, to: .greenFirstScreen))
        XCTAssertTrue(State.isValidTransition(from: .greenThirdScreen(nil), to: .greenSecondScreen))
        XCTAssertTrue(State.isValidTransition(from: .greenThirdScreen(nil), to: .greenFirstScreen))

        XCTAssertFalse(State.isValidTransition(from: .none, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .none, to: .greenSecondScreen))
        XCTAssertFalse(State.isValidTransition(from: .none, to: .greenThirdScreen(nil)))
        XCTAssertFalse(State.isValidTransition(from: .greenFirstScreen, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .greenFirstScreen, to: .greenFirstScreen))
        XCTAssertFalse(State.isValidTransition(from: .greenFirstScreen, to: .greenThirdScreen(nil)))
        XCTAssertFalse(State.isValidTransition(from: .greenSecondScreen, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .greenThirdScreen(nil), to: .none))
    }

    // MARK: - Flow Tests
    func testSuccessOfGreenFlowTransitionFromInitialToFirstScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenFirstScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    func testSuccessOfGreenFlowTransitionFromFirstToSecondScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenSecondScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 2)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)
    }

    func testFailOfGreenFlowTransitionFromInitialToThirdScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenThirdScreen(nil)

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    func testSuccessOfGreenFlowTransitionFromSecondToFirstScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenSecondScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 2)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)

        coordinator.state = .greenFirstScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    func testSuccessOfGreenFlowTransitionFromSecondToThirdScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenSecondScreen
        coordinator.state = .greenThirdScreen(nil)

        XCTAssertEqual(flowNavigationController.viewControllers.count, 3)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[2] is GreenThirdViewController)
    }

    func testFailOfGreenFlowTransitionFromFirstToThirdScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenThirdScreen(nil)

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    func testSuccessOfGreenFlowTransitionFromThirdToSecondScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenSecondScreen
        coordinator.state = .greenThirdScreen(nil)

        XCTAssertEqual(flowNavigationController.viewControllers.count, 3)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[2] is GreenThirdViewController)

        coordinator.state = .greenSecondScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 2)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)
    }

    func testSuccessOfGreenFlowTransitionFromThirdToFirstScreenState() throws {
        coordinator.start()
        assertBasics()

        coordinator.state = .greenSecondScreen
        coordinator.state = .greenThirdScreen(nil)

        XCTAssertEqual(flowNavigationController.viewControllers.count, 3)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[1] is GreenSecondViewController)
        XCTAssertTrue(flowNavigationController.viewControllers[2] is GreenThirdViewController)

        coordinator.state = .greenFirstScreen

        XCTAssertEqual(flowNavigationController.viewControllers.count, 1)
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

    // MARK: - Private methods
    private func assertBasics() {
        XCTAssertTrue(flowNavigationController.viewControllers[0] is GreenFirstViewController)
    }

}
