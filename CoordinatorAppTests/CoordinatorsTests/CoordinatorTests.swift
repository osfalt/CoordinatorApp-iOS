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
        
    // MARK: - Authorization Flow Tests
    
    func testSignInSceneDidTapCreateAccountButton_NavigatesToSignUpScene() {
        sut.start()
        sut.signInSceneDidTapCreateAccountButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .signInScene])
        XCTAssertEqual(sut.authorizationScenes, [.signInScene, .signUpScene])
        XCTAssertEqual(sut.redFlowScenes, [])
        XCTAssertEqual(sut.greenFlowScenes, [])
        XCTAssertEqual(sut.settingsScenes, [])
        
        XCTAssertEqual(sut.currentRootScene, .signInScene)
        XCTAssertEqual(sut.currentAuthorizationScene, .signUpScene)
        XCTAssertEqual(sut.currentRedFlowScene, nil)
        XCTAssertEqual(sut.currentGreenFlowScene, nil)
        XCTAssertEqual(sut.currentSettingsScene, nil)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow)),
                .continueFlow(source: .signInScene, destination: .signUpScene)
            ]
        )
    }
    
    func testSignInSceneDidLogInSuccessfully_NavigatesToMainFlow() {
        sut.start()
        sut.signInSceneDidLogInSuccessfully()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.authorizationScenes, [])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentAuthorizationScene, nil)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow)),
                .completeFlow(scene: .signInScene, style: .unembed),
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
            ]
        )
    }
    
    func testSignUpSceneDidRegisterSuccessfully_NavigatesToMainFlow() {
        sut.start()
        sut.signInSceneDidTapCreateAccountButton()
        sut.signUpSceneDidRegisterSuccessfully()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.authorizationScenes, [])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentAuthorizationScene, nil)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow)),
                .continueFlow(source: .signInScene, destination: .signUpScene),
                .completeFlow(scene: .signUpScene, style: .unembed),
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
            ]
        )
    }
    
    func testSignUpSceneDidTapBackButton_NavigatesToSignInScene() {
        sut.start()
        sut.signInSceneDidTapCreateAccountButton()
        sut.signUpSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .signInScene])
        XCTAssertEqual(sut.authorizationScenes, [.signInScene])
        XCTAssertEqual(sut.redFlowScenes, [])
        XCTAssertEqual(sut.greenFlowScenes, [])
        XCTAssertEqual(sut.settingsScenes, [])
        
        XCTAssertEqual(sut.currentRootScene, .signInScene)
        XCTAssertEqual(sut.currentAuthorizationScene, .signInScene)
        XCTAssertEqual(sut.currentRedFlowScene, nil)
        XCTAssertEqual(sut.currentGreenFlowScene, nil)
        XCTAssertEqual(sut.currentSettingsScene, nil)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .signInScene, style: .embed(mode: .flow)),
                .continueFlow(source: .signInScene, destination: .signUpScene),
                .goBackInFlow(source: .signUpScene, destination: nil)
            ]
        )
    }
    
    // MARK: - Red Flow Tests
    
    func testRedFirstSceneDidTapNextButton_NavigatesToRedSecondScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redSecondScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene)
            ]
        )
    }
    
    func testRedSecondSceneDidTapNextButton_NavigatesToRedDynamicInfoScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene, .redDynamicInfoScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redDynamicInfoScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene)
            ]
        )
    }
    
    func testRedSecondSceneDidTapBackButton_NavigatesToRedFirstScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .goBackInFlow(source: .redSecondScene, destination: nil)
            ]
        )
    }
    
    func testRedDynamicInfoSceneDidTapBackButton_NavigatesToRedSecondScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapNextButton()
        sut.redDynamicInfoSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redSecondScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene),
                .goBackInFlow(source: .redDynamicInfoScene, destination: nil)
            ]
        )
    }
    
    // MARK: - Green Flow Tests
    
    func testGreenFirstSceneDidTapNextButton_NavigatesToGreenSecondScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenSecondScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene)
            ]
        )
    }
    
    func testGreenSecondSceneDidTapNextButton_NavigatesToGreenThirdScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene, .greenThirdScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenThirdScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene)
            ]
        )
    }
    
    func testGreenSecondSceneDidTapBackButton_NavigatesToGreenFirstScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .goBackInFlow(source: .greenSecondScene, destination: nil)
            ]
        )
    }
    
    func testGreenThirdSceneDidTapBackButton_NavigatesToGreenSecondScene() {
        givenUserIsLoggedIn()
        
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapNextButton()
        sut.greenThirdSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene])
        XCTAssertEqual(sut.settingsScenes, [.settingsScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenSecondScene)
        XCTAssertEqual(sut.currentSettingsScene, .settingsScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .settingsScene, style: .tabBar(.settingsItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene),
                .goBackInFlow(source: .greenThirdScene, destination: nil)
            ]
        )
    }
    
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
