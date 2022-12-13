//
//  CoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 10/12/2022.
//

import XCTest
@testable import CoordinatorApp

final class CoordinatorTests: XCTestCase {
    
    private var navigatorSpy: NavigatorSpy!
    private var factory: SceneFactory<MockScene>!
    private var sut: Coordinator<MockScene>!

    override func setUp() {
        super.setUp()
        
        navigatorSpy = NavigatorSpy()
        factory = SceneFactory<MockScene>.mock()
        sut = Coordinator(navigator: navigatorSpy.navigator, factory: factory, interactor: DependenciesMock())
    }
    
    // MARK: - Start Tests

    func testStartCoordinator() {
        let rootScene = sut.start()
        
        XCTAssertEqual(rootScene, .rootScene)
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem))
            ]
        )
    }
    
    // MARK: - Red Flow Tests
    
    func testRedFirstSceneDidTapNextButton_NavigatesToRedSecondScene() {
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redSecondScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene)
            ]
        )
    }
    
    func testRedSecondSceneDidTapNextButton_NavigatesToRedDynamicInfoScene() {
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene, .redDynamicInfoScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redDynamicInfoScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene)
            ]
        )
    }
    
    func testRedSecondSceneDidTapBackButton_NavigatesToRedFirstScene() {
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .goBackInFlow(source: .redSecondScene, destination: nil)
            ]
        )
    }
    
    func testRedDynamicInfoSceneDidTapBackButton_NavigatesToRedSecondScene() {
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapNextButton()
        sut.redDynamicInfoSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redSecondScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene),
                .goBackInFlow(source: .redDynamicInfoScene, destination: nil)
            ]
        )
    }
    
    // MARK: - Green Flow Tests
    
    func testGreenFirstSceneDidTapNextButton_NavigatesToGreenSecondScene() {
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenSecondScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene)
            ]
        )
    }
    
    func testGreenSecondSceneDidTapNextButton_NavigatesToGreenThirdScene() {
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapNextButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene, .greenThirdScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenThirdScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene)
            ]
        )
    }
    
    func testGreenSecondSceneDidTapBackButton_NavigatesToGreenFirstScene() {
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenFirstScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .goBackInFlow(source: .greenSecondScene, destination: nil)
            ]
        )
    }
    
    func testGreenThirdSceneDidTapBackButton_NavigatesToGreenSecondScene() {
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapNextButton()
        sut.greenThirdSceneDidTapBackButton()
        
        XCTAssertEqual(sut.rootScenes, [.rootScene, .mainTabBarScene])
        XCTAssertEqual(sut.redFlowScenes, [.redFirstScene])
        XCTAssertEqual(sut.greenFlowScenes, [.greenFirstScene, .greenSecondScene])
        
        XCTAssertEqual(sut.currentRootScene, .mainTabBarScene)
        XCTAssertEqual(sut.currentRedFlowScene, .redFirstScene)
        XCTAssertEqual(sut.currentGreenFlowScene, .greenSecondScene)
        
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .newFlow(source: .rootScene, destination: .mainTabBarScene, style: .embed(mode: .single)),
                .newFlow(source: .mainTabBarScene, destination: .redFirstScene, style: .tabBar(.redFlowItem)),
                .newFlow(source: .mainTabBarScene, destination: .greenFirstScene, style: .tabBar(.greenFlowItem)),
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene),
                .goBackInFlow(source: .greenThirdScene, destination: nil)
            ]
        )
    }

}
