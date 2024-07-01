//
//  AppCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 01/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class AppCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: AppCoordinator<MockScene>!
    
    override func setUp() {
        super.setUp()
        
        sut = AppCoordinator(navigator: navigatorSpy, factory: factoryMock, interactor: dependenciesMock)
    }
    
    func testStartForGuestUser_NavigatesToAuthorizationFlow() {
        // given
        givenUserIsGuest()
        
        // when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .rootScene)
        XCTAssertEqual(sut.scenes, [.rootScene])
        XCTAssertEqual(sut.currentScene, .rootScene)
        
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children[0].scenes as? [MockScene], [.signInScene])
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow))
            ]
        )
    }
    
    func testStartForLoggedInUser_NavigatesToMainFlow() {
        // given
        givenUserIsLoggedIn()
        
        // when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .rootScene)
        XCTAssertEqual(sut.scenes, [.rootScene])
        XCTAssertEqual(sut.currentScene, .rootScene)
        
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children[0].scenes as? [MockScene], [.mainTabBarScene])
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
            ]
        )
    }
    
    func testAuthorizationCoordinatorDidFinish_NavigatesToMainFlow() {
        // given
        givenUserIsGuest()
        
        // when
        sut.start()
        sut.authorizationCoordinatorDidFinish()
        
        // then
        XCTAssertEqual(sut.scenes, [.rootScene])
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children[0].scenes as? [MockScene], [.mainTabBarScene])
        
        XCTAssertEqual(
            navigatorSpy.log.last,
            .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single))
        )
    }
    
    func testMainTabBarCoordinatorDidFinish_NavigatesToAuthorizationFlow() {
        // given
        givenUserIsLoggedIn()
        
        // when
        sut.start()
        sut.mainTabBarCoordinatorDidFinish()
        
        // then
        XCTAssertEqual(sut.scenes, [.rootScene])
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children[0].scenes as? [MockScene], [.signInScene])
        
        XCTAssertEqual(
            navigatorSpy.log.last,
            .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow))
        )
    }
    
}
