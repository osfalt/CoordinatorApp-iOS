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
    private var flowNavigationVC: BaseNavigationController!

    override func setUpWithError() throws {
        factory = MockAuthorizationFlowFactory()
        flowNavigationVC = factory.flowNavigationVC
        coordinator = AuthorizationCoordinator(flowNavigationController: flowNavigationVC, flowFactory: factory)
        coordinator.animationEnabled = false
    }

    // MARK: - Flow Tests

    func testStateAfterStart() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .signIn)
    }

    func testTransitionForwardFromSignInToSignUpState() throws {
        coordinator.start()
        XCTAssertEqual(coordinator.state, .signIn)
        XCTAssertNotNil(factory.signInViewController)

        let signInViewController = try XCTUnwrap(factory.signInViewController)
        signInViewController.tapOnCreateAccountButton()
        XCTAssertEqual(coordinator.state, .signUp)
        XCTAssertNotNil(factory.signUpViewController)
    }

    func testTransitionBackFromSignUpToSignInState() throws {
        fixPopViewController()

        // open sign-in screen
        coordinator.start()
        let signInViewController = try XCTUnwrap(factory.signInViewController)
        signInViewController.tapOnCreateAccountButton()
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .signUp)
        XCTAssertNotNil(factory.signUpViewController)
        
        // test pop transition
        flowNavigationVC.popViewController(animated: false)
        RunLoop.current.run(until: Date())
        XCTAssertEqual(coordinator.state, .signIn)
    }

    /// This method fixes callbacks of `NavigationControllerDelegate`
    private func fixPopViewController() {
        UIApplication.shared.windows.first?.rootViewController = flowNavigationVC
    }

}
