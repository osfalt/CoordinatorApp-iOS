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
    private var flowNavigationVC: UINavigationController!

    override func setUpWithError() throws {
        factory = MockRedFlowFactory()
        coordinator = RedFlowCoordinator(flowNavigationController: factory.redFlowNavigationVC, flowFactory: factory)
        flowNavigationVC = factory.redFlowNavigationVC
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)
    }

    func testTransitionForwardFromRedFirstToSecondState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    func testTransitionForwardFromRedSecondToDynamicState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
    }

    func testTransitionBackFromRedSecondToFirstState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open red second screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redFirstScreen)
    }

    func testTransitionBackFromRedDynamicToSecondState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open red dynamic screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)

        // test pop transition
        flowNavigationVC.popViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    func testTransitionBackFromRedDynamicToFirstState() throws {
        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // open red dynamic screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)

        // test pop to root transition
        flowNavigationVC.popToRootViewController(animated: true)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .redFirstScreen)
    }

    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
    }

}
