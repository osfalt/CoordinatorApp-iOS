//
//  MainTabBarCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 02/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class MainTabBarCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: MainTabBarCoordinator<MockScene>!
    private var delegateSpy: MainTabBarCoordinatorDelegateSpy!
    
    override func setUp() {
        super.setUp()
        
        delegateSpy = MainTabBarCoordinatorDelegateSpy()
        sut = MainTabBarCoordinator(navigator: navigatorSpy, factory: factoryMock, delegate: delegateSpy)
    }
    
    func testStart_NavigatesToSignInScene() {
        // given/when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .mainTabBarScene)
        XCTAssertEqual(sut.scenes, [.mainTabBarScene])
        XCTAssertEqual(sut.currentScene, .mainTabBarScene)
        
        XCTAssertEqual(sut.children.count, 3)
        XCTAssertEqual(sut.children[0].scenes as? [MockScene], [.redFirstScene])
        XCTAssertEqual(sut.children[1].scenes as? [MockScene], [.greenFirstScene])
        XCTAssertEqual(sut.children[2].scenes as? [MockScene], [.settingsScene])
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
            ]
        )
        XCTAssertEqual(delegateSpy.log, [])
    }
    
    func testSettingsCoordinatorDidFinish_FinishesFlow() {
        // given
        sut.start()
        
        // when
        sut.settingsCoordinatorDidFinish()
        
        // then
        XCTAssertEqual(sut.scenes, [.mainTabBarScene])
        XCTAssertEqual(sut.currentScene, .mainTabBarScene)
        
        XCTAssertEqual(sut.children.count, 3)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
            ]
        )
        XCTAssertEqual(delegateSpy.log, [.mainTabBarCoordinatorDidFinish])
    }
    
}

// MARK: - Mocks

private final class MainTabBarCoordinatorDelegateSpy: MainTabBarCoordinatorDelegate {
    enum MethodCall {
        case mainTabBarCoordinatorDidFinish
    }
    
    private(set) var log: [MethodCall] = []
    
    func mainTabBarCoordinatorDidFinish() {
        log.append(.mainTabBarCoordinatorDidFinish)
    }
}
