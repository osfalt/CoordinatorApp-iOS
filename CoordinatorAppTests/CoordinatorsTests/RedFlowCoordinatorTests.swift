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

    private var coordinator: RedFlowCoordinator!
    private var factory: MockRedFlowFactory!
    private var flowNavigationVC: BaseNavigationController!

    override func setUpWithError() throws {
        factory = MockRedFlowFactory()
        flowNavigationVC = factory.redFlowNavigationVC
        coordinator = RedFlowCoordinator(flowNavigationController: flowNavigationVC, flowFactory: factory)
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redFirstViewController)
    }

    func testTransitionForwardFromRedFirstToSecondState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redFirstViewController)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redSecondViewController)
    }

    func testTransitionForwardFromRedSecondToDynamicState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redFirstViewController)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redSecondViewController)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redDynamicController)
    }

    func testTransitionBackFromRedSecondToFirstState() throws {
        fixPopViewController()

        // open red second screen
        coordinator.start()
        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redSecondViewController)

        // test pop transition
        flowNavigationVC.popViewController(animated: false)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redFirstViewController)
    }

    func testTransitionBackFromRedDynamicToSecondState() throws {
        fixPopViewController()

        // open red dynamic screen
        coordinator.start()
        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redDynamicController)

        // test pop transition
        flowNavigationVC.popViewController(animated: false)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redSecondScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redSecondViewController)
    }

    func testTransitionBackFromRedDynamicToFirstState() throws {
        fixPopViewController()

        // open red dynamic screen
        coordinator.start()
        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redDynamicController)

        // test pop to root transition
        flowNavigationVC.popToRootViewController(animated: false)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redFirstScreen)
        XCTAssertTrue(flowNavigationVC.topViewController === factory.redFirstViewController)
    }


    /// This method fixes callbacks of `NavigationControllerDelegate`
    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
    }

}
