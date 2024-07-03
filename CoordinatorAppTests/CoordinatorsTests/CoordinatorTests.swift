//
//  CoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 10/12/2022.
//

import XCTest
@testable import CoordinatorApp

/*
final class CoordinatorTests: XCTestCase {
    
    // MARK: - Settings Tests
    
    func testSettingsSceneDidLogoutSuccessfullyn_NavigatesToAuthorizationFlow() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.settingsSceneDidLogoutSuccessfully()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .signInScene])
        XCTAssertEqual(sut.redFlowScenes, [])
        XCTAssertEqual(sut.greenFlowScenes, [])
        XCTAssertEqual(sut.settingsScenes, [])
        
        XCTAssertEqual(sut.currentRootScene, .signInScene)
        XCTAssertEqual(sut.currentRedFlowScene, nil)
        XCTAssertEqual(sut.currentGreenFlowScene, nil)
        XCTAssertEqual(sut.currentSettingsScene, nil)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .completeFlow(scene: .mainTabBarScene, style: .unembed),
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow))
            ]
        )
    }

}
*/
