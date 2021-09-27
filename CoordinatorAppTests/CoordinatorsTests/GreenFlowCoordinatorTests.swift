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

    private var coordinator: GreenFlowCoordinator!
    private var factory: MockGreenFlowFactory!
    private var flowNavigationVC: UINavigationController!

    override func setUpWithError() throws {
        factory = MockGreenFlowFactory()
        coordinator = GreenFlowCoordinator(flowNavigationController: factory.greenFlowNavigationVC, flowFactory: factory)
        flowNavigationVC = factory.greenFlowNavigationVC
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
    }

    func testTransitionForwardFromGreenFirstToSecondState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
    }

    func testTransitionForwardFromGreenSecondToThirdState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))
    }

    func testTransitionBackFromGreenSecondToFirstState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open green second screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
    }

    func testTransitionBackFromGreenThirdToSecondState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open green third screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
    }

    func testTransitionBackFromGreenThirdToFirstState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open green third screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))

        // test pop to root transition
        flowNavigationVC.popToRootViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
    }

    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
    }

}