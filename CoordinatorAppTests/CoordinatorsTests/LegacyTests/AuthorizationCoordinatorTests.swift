//
//  AuthorizationCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 28/09/2021.
//

import UIKit
import XCTest
@testable import CoordinatorApp

class AuthorizationCoordinatorTests: XCTestCase {

    private var coordinator: AuthorizationCoordinator!
    private var factory: MockAuthorizationFlowFactory!
    private var flowNavigationRouter: MockNavigationRouter!

    override func setUpWithError() throws {
        factory = MockAuthorizationFlowFactory()
        flowNavigationRouter = factory.flowNavigationRouter
        coordinator = AuthorizationCoordinator(
            flowNavigationRouter: flowNavigationRouter,
            flowFactory: factory,
            authorizationTokenStore: AuthorizationTokenStore(store: UserDefaults.standard)
        )
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .signIn)
    }

    func testTransitionForwardFromSignInToSignUpState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .signIn)
        XCTAssertTrue(flowNavigationRouter.top === factory.signInViewController)

        let signInViewController = try XCTUnwrap(factory.signInViewController)
        signInViewController.tapOnCreateAccountButton()
        XCTAssertEqual(coordinator.state, .signUp)
        XCTAssertTrue(flowNavigationRouter.top === factory.signUpViewController)
    }

    func testTransitionBackFromSignUpToSignInState() throws {
        // open sign-in screen
        coordinator.start()
        let signInViewController = try XCTUnwrap(factory.signInViewController)
        signInViewController.tapOnCreateAccountButton()
        XCTAssertEqual(coordinator.state, .signUp)
        XCTAssertTrue(flowNavigationRouter.top === factory.signUpViewController)
        
        // test pop transition
        flowNavigationRouter.pop()
        XCTAssertEqual(coordinator.state, .signIn)
        XCTAssertTrue(flowNavigationRouter.top === factory.signInViewController)
    }

}
