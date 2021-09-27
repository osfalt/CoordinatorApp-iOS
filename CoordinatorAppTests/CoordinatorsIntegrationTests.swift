//
//  CoordinatorsIntegrationTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 27/09/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class CoordinatorsIntegrationTests: XCTestCase {

    private var mainFlowFactory: MockMainFlowFactory!
    private var redFlowFactory: MockRedFlowFactory!
    private var greenFlowFactory: MockGreenFlowFactory!

    private var tabBarController: MockTabBarController!
    private var mainCoordinator: MainCoordinator!

    override func setUpWithError() throws {
        redFlowFactory = MockRedFlowFactory()
        greenFlowFactory = MockGreenFlowFactory()
        mainFlowFactory = MockMainFlowFactory(redFlow: redFlowFactory, greenFlow: greenFlowFactory)

        tabBarController = MockTabBarController()
        mainCoordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: mainFlowFactory)
        mainCoordinator.animationEnabled = false
    }

    // MARK: - Tests

    func testOpenRedFlow() throws {
        mainCoordinator.start()
        tabBarController.selectRedFlowTab()

        let redFlowCoordinator = try XCTUnwrap(redFlowFactory.coordinator)
        XCTAssertEqual(redFlowCoordinator.state, .redFirstScreen)
    }

    func testOpenGreenFlow() throws {
        mainCoordinator.start()
        tabBarController.selectRedFlowTab()

        let greenFlowCoordinator = try XCTUnwrap(greenFlowFactory.coordinator)
        XCTAssertEqual(greenFlowCoordinator.state, .greenFirstScreen)
    }

}
