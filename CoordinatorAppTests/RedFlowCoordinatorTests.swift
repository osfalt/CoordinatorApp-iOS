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
    private var builder: MockRedFlowBuilder!

    override func setUpWithError() throws {
        flowNavigationController = BaseNavigationController()
        builder = MockRedFlowBuilder()

        coordinator = RedFlowCoordinator(flowNavigationController: flowNavigationController, builder: builder)
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)
    }

    func testTransitionFromRedFirstToSecondScreenState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(builder.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    func testTransitionFromRedSecondToDynamicScreenState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(builder.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(builder.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
    }

    #warning("TODO: Tests for pop VCs")

}
