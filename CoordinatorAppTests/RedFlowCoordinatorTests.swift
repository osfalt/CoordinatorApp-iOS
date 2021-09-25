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

    override func setUpWithError() throws {
        factory = MockRedFlowFactory()
        coordinator = RedFlowCoordinator(flowNavigationController: factory.redFlowNavigationVC, flowFactory: factory)
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

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)
    }

    func testTransitionFromRedSecondToDynamicScreenState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFirstScreen)

        let redFirstViewController = try XCTUnwrap(factory.redFirstViewController)
        redFirstViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redSecondScreen)

        let redSecondViewController = try XCTUnwrap(factory.redSecondViewController)
        redSecondViewController.tapOnNextButton()
        XCTAssertEqual(coordinator.state, .redDynamicInfoScreen)
    }

    #warning("TODO: Tests for pop VCs")

}
