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

    private var factory: MockRedFlowFactory!
    private var coordinator: RedFlowCoordinator!
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
        // open red second screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // test pop transition
        flowNavigationVC.popViewController(animated: false)
        XCTAssertEqual(coordinator.state, .redFirstScreen)
    }

    func testTransitionBackFromRedDynamicToSecondState() throws {
        // open red dynamic screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)

        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()

        // test pop transition
        flowNavigationVC.popViewController(animated: false)
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    func testTransitionBackFromRedDynamicToFirstState() throws {
        // open red dynamic screen
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)

        // without this `NavigationControllerDelegate` callbacks don't work
        fixPopViewController()
        
        // test pop to root transition
        flowNavigationVC.popToRootViewController(animated: false)
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
        RunLoop.current.run(until: Date())
    }

}
