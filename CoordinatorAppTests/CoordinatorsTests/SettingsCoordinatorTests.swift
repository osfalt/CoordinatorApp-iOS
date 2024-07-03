//
//  SettingsCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 03/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class SettingsCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: SettingsCoordinator<MockScene>!
    private var delegate: SettingsCoordinatorDelegateSpy!
    
    override func setUp() {
        super.setUp()
        
        delegate = SettingsCoordinatorDelegateSpy()
        sut = SettingsCoordinator(navigator: navigatorSpy, factory: factoryMock, delegate: delegate)
    }
    
    func testStart_NavigatesToSettingsScene() {
        // given/when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .settingsScene)
        XCTAssertEqual(sut.scenes, [.settingsScene])
        XCTAssertEqual(sut.currentScene, .settingsScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
        XCTAssertEqual(delegate.log, [])
    }
    
    func testSettingsSceneDidLogoutSuccessfully_FinishesFlow() {
        // given
        sut.start()

        // when
        sut.settingsSceneDidLogoutSuccessfully()

        // then
        XCTAssertEqual(sut.scenes, [.settingsScene])
        XCTAssertEqual(sut.currentScene, .settingsScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
        XCTAssertEqual(delegate.log, [.settingsCoordinatorDidFinish])
    }
    
}

// MARK: - Mocks

private final class SettingsCoordinatorDelegateSpy: SettingsCoordinatorDelegate {
    enum MethodCall {
        case settingsCoordinatorDidFinish
    }
    
    private(set) var log: [MethodCall] = []
    
    func settingsCoordinatorDidFinish() {
        log.append(.settingsCoordinatorDidFinish)
    }
}
