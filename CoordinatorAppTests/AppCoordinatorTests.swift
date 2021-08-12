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

    // MARK: - Transitions Tests

    func testInterfaceStateTransitionsValidity() throws {
        typealias State = AppCoordinator.InterfaceState

        #warning("TODO: REMOVE State.isValidTransition?")
        XCTAssertTrue(State.isValidTransition(from: .none, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .none, to: .greenFlow))
        XCTAssertTrue(State.isValidTransition(from: .redFlow, to: .greenFlow))
        XCTAssertTrue(State.isValidTransition(from: .redFlow, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .greenFlow, to: .redFlow))
        XCTAssertTrue(State.isValidTransition(from: .greenFlow, to: .greenFlow))

        XCTAssertFalse(State.isValidTransition(from: .none, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .redFlow, to: .none))
        XCTAssertFalse(State.isValidTransition(from: .greenFlow, to: .none))
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
