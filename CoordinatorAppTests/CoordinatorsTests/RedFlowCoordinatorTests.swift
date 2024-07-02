//
//  RedFlowCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 02/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class RedFlowCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: RedFlowCoordinator<MockScene>!
    
    override func setUp() {
        super.setUp()
        
        sut = RedFlowCoordinator(navigator: navigatorSpy, factory: factoryMock)
    }
    
    func testStart_NavigatesToRedFirstScene() {
        // given/when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .redFirstScene)
        XCTAssertEqual(sut.scenes, [.redFirstScene])
        XCTAssertEqual(sut.currentScene, .redFirstScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
    }
    
    func testRedFirstSceneDidTapNextButton_NavigatesToRedSecondScene() {
        // given
        sut.start()

        // when
        sut.redFirstSceneDidTapNextButton()

        // then
        XCTAssertEqual(sut.scenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.currentScene, .redSecondScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [.continueFlow(source: .redFirstScene, destination: .redSecondScene)])
    }
    
    func testRedSecondSceneDidTapNextButton_NavigatesToRedDynamicInfoScene() {
        // given
        sut.start()
        sut.redFirstSceneDidTapNextButton()

        // when
        sut.redSecondSceneDidTapNextButton()

        // then
        XCTAssertEqual(sut.scenes, [.redFirstScene, .redSecondScene, .redDynamicInfoScene])
        XCTAssertEqual(sut.currentScene, .redDynamicInfoScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene),
            ]
        )
    }
    
    func testRedSecondSceneDidTapBackButton_NavigatesToRedFirstScene() {
        // given
        sut.start()
        sut.redFirstSceneDidTapNextButton()

        // when
        sut.redSecondSceneDidTapBackButton()

        // then
        XCTAssertEqual(sut.scenes, [.redFirstScene])
        XCTAssertEqual(sut.currentScene, .redFirstScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .goBackInFlow(source: .redSecondScene, destination: nil),
            ]
        )
    }
    
    func testRedDynamicInfoSceneDidTapBackButton_NavigatesToRedSecondScene() {
        // given
        sut.start()
        sut.redFirstSceneDidTapNextButton()
        sut.redSecondSceneDidTapNextButton()

        // when
        sut.redDynamicInfoSceneDidTapBackButton()

        // then
        XCTAssertEqual(sut.scenes, [.redFirstScene, .redSecondScene])
        XCTAssertEqual(sut.currentScene, .redSecondScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .redFirstScene, destination: .redSecondScene),
                .continueFlow(source: .redSecondScene, destination: .redDynamicInfoScene),
                .goBackInFlow(source: .redDynamicInfoScene, destination: nil),
            ]
        )
    }
    
}
