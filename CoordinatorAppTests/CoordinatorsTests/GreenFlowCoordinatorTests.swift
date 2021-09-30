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
    private var flowNavigationVC: BaseNavigationController!

    override func setUpWithError() throws {
        factory = MockGreenFlowFactory()
        flowNavigationVC = factory.greenFlowNavigationVC
        coordinator = GreenFlowCoordinator(flowNavigationController: flowNavigationVC, flowFactory: factory)
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenFirstViewController)
    }

    func testTransitionForwardFromGreenFirstToSecondState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenFirstViewController)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenSecondViewController)
    }

    func testTransitionForwardFromGreenSecondToThirdState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .greenFirstScreen)

        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenSecondViewController)

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenThirdViewController)
    }

    func testTransitionBackFromGreenSecondToFirstState() throws {
        fixPopViewController()

        // open green second screen
        coordinator.start()
        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenSecondViewController)

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenFirstViewController)
    }

    func testTransitionBackFromGreenThirdToSecondState() throws {
        fixPopViewController()

        // open green third screen
        coordinator.start()
        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenThirdViewController)

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenSecondViewController)
    }

    func testTransitionBackFromGreenThirdToFirstState() throws {
        fixPopViewController()

        // open green third screen
        coordinator.start()
        let greenFirstViewController = try XCTUnwrap(factory.greenFirstViewController)
        greenFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())

        let greenSecondViewController = try XCTUnwrap(factory.greenSecondViewController)
        greenSecondViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenThirdScreen(nil))
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenThirdViewController)

        // test pop to root transition
        flowNavigationVC.popToRootViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .greenFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.greenFirstViewController)
    }

    /// This method fixes callbacks of `NavigationControllerDelegate`
    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
    }

}
