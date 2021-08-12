//
//  AppCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 03/08/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class AppCoordinatorTests: XCTestCase {

    private var rootViewController: UIViewController!
    private var coordinator: AppCoordinator!
    private var builder: MockFlowsBuilder!

    override func setUpWithError() throws {
        rootViewController = UIViewController()
        builder = MockFlowsBuilder(redFlow: RedFlowBuilder(), greenFlow: GreenFlowBuilder())

        coordinator = AppCoordinator(rootViewController: rootViewController, builder: builder)
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests
    
    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFlow)
    }

    func testRedFlowScreenState() throws {
        coordinator.start()
        builder.tabBarController.selectRedFlowTab()
        XCTAssertEqual(coordinator.state, .redFlow)
    }

    func testGreenFlowScreenState() throws {
        coordinator.start()
        builder.tabBarController.selectGreenFlowTab()
        XCTAssertEqual(coordinator.state, .greenFlow)
    }

}
