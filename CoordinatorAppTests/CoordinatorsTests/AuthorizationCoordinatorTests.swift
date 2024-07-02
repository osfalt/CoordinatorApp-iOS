//
//  AuthorizationCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 01/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class AuthorizationCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: AuthorizationCoordinator<MockScene>!
    private var delegateSpy: AuthorizationCoordinatorDelegateSpy!
    
    override func setUp() {
        super.setUp()
        
        delegateSpy = AuthorizationCoordinatorDelegateSpy()
        sut = AuthorizationCoordinator(navigator: navigatorSpy, factory: factoryMock, delegate: delegateSpy)
    }
    
    func testStart_NavigatesToSignInScene() {
        // given/when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .signInScene)
        XCTAssertEqual(sut.scenes, [.signInScene])
        XCTAssertEqual(sut.currentScene, .signInScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
        XCTAssertEqual(delegateSpy.log, [])
    }
    
    func testSignInSceneDidTapCreateAccountButton_NavigatesToSignUpScene() {
        // given
        sut.start()
        
        // when
        sut.signInSceneDidTapCreateAccountButton()
        
        // then
        XCTAssertEqual(sut.scenes, [.signInScene, .signUpScene])
        XCTAssertEqual(sut.currentScene, .signUpScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [.continueFlow(source: .signInScene, destination: .signUpScene)])
        XCTAssertEqual(delegateSpy.log, [])
    }
    
    func testSignInSceneDidLogInSuccessfully_FinishesFlow() {
        // given
        sut.start()
        
        // when
        sut.signInSceneDidLogInSuccessfully()
        
        // then
        XCTAssertEqual(sut.scenes, [.signInScene])
        XCTAssertEqual(sut.currentScene, .signInScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
        XCTAssertEqual(delegateSpy.log, [.authorizationCoordinatorDidFinish])
    }
    
    func testSignUpSceneDidTapBackButton_NavigatesBackToSignInScene() {
        // given
        sut.start()
        sut.signInSceneDidTapCreateAccountButton()
        
        // when
        sut.signUpSceneDidTapBackButton()
        
        // then
        XCTAssertEqual(sut.scenes, [.signInScene])
        XCTAssertEqual(sut.currentScene, .signInScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .signInScene, destination: .signUpScene),
                .goBackInFlow(source: .signUpScene, destination: nil)
            ]
        )
        XCTAssertEqual(delegateSpy.log, [])
    }
    
    func testSignUpSceneDidRegisterSuccessfully_FinishesFlow() {
        // given
        sut.start()
        
        // when
        sut.signUpSceneDidRegisterSuccessfully()
        
        // then
        XCTAssertEqual(sut.scenes, [.signInScene])
        XCTAssertEqual(sut.currentScene, .signInScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
        XCTAssertEqual(delegateSpy.log, [.authorizationCoordinatorDidFinish])
    }
    
}

// MARK: - Mocks

private final class AuthorizationCoordinatorDelegateSpy: AuthorizationCoordinatorDelegate {
    enum MethodCall {
        case authorizationCoordinatorDidFinish
    }
    
    private(set) var log: [MethodCall] = []
    
    func authorizationCoordinatorDidFinish() {
        log.append(.authorizationCoordinatorDidFinish)
    }
}
