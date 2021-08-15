//
//  MainCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 03/08/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class MainCoordinatorTests: XCTestCase {

    private var tabBarController: MockTabBarController!
    private var coordinator: MainCoordinator!

    override func setUpWithError() throws {
        tabBarController = MockTabBarController()
        coordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: DummyMainFlowFactory())
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests
    
    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .redFlow)
    }

    func testRedFlowScreenState() throws {
        coordinator.start()
        tabBarController.selectRedFlowTab()
        XCTAssertEqual(coordinator.state, .redFlow)
    }

    func testGreenFlowScreenState() throws {
        coordinator.start()
        tabBarController.selectGreenFlowTab()
        XCTAssertEqual(coordinator.state, .greenFlow)
    }

}

// MARK: - Dummy Object

private final class DummyMainFlowFactory: MainFlowFactoryProtocol {
    let redFlow: RedFlowFactoryProtocol = RedFlowFactory()
    let greenFlow: GreenFlowModuleFactoryProtocol = GreenFlowModuleFactory()

    func makeFlow() -> MainFlow {
        let tabBarController = UITabBarController()
        let coordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: self)
        return (tabBarController, coordinator)
    }
}
