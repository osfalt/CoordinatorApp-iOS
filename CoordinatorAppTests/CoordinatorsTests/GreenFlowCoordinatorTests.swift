//
//  GreenFlowCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 03/07/2024.
//

import XCTest
@testable import CoordinatorApp

final class GreenFlowCoordinatorTests: BaseCoordinatorTests {
    
    private var sut: GreenFlowCoordinator<MockScene>!
    
    override func setUp() {
        super.setUp()
        
        sut = GreenFlowCoordinator(navigator: navigatorSpy, factory: factoryMock)
    }
    
    func testStart_NavigatesToGreenFirstScene() {
        // given/when
        let scene = sut.start()
        
        // then
        XCTAssertEqual(scene, .greenFirstScene)
        XCTAssertEqual(sut.scenes, [.greenFirstScene])
        XCTAssertEqual(sut.currentScene, .greenFirstScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [])
    }
    
    func testGreenFirstSceneDidTapNextButton_NavigatesToGreenSecondScene() {
        // given
        sut.start()

        // when
        sut.greenFirstSceneDidTapNextButton()

        // then
        XCTAssertEqual(sut.scenes, [.greenFirstScene, .greenSecondScene])
        XCTAssertEqual(sut.currentScene, .greenSecondScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(navigatorSpy.log, [.continueFlow(source: .greenFirstScene, destination: .greenSecondScene)])
    }

    func testGreenSecondSceneDidTapNextButton_NavigatesToGreenThirdScene() {
        // given
        sut.start()
        sut.greenFirstSceneDidTapNextButton()

        // when
        sut.greenSecondSceneDidTapNextButton()

        // then
        XCTAssertEqual(sut.scenes, [.greenFirstScene, .greenSecondScene, .greenThirdScene])
        XCTAssertEqual(sut.currentScene, .greenThirdScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene),
            ]
        )
    }

    func testGreenSecondSceneDidTapBackButton_NavigatesToGreenFirstScene() {
        // given
        sut.start()
        sut.greenFirstSceneDidTapNextButton()

        // when
        sut.greenSecondSceneDidTapBackButton()

        // then
        XCTAssertEqual(sut.scenes, [.greenFirstScene])
        XCTAssertEqual(sut.currentScene, .greenFirstScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .goBackInFlow(source: .greenSecondScene, destination: nil),
            ]
        )
    }

    func testGreenThirdSceneDidTapBackButton_NavigatesToGreenSecondScene() {
        // given
        sut.start()
        sut.greenFirstSceneDidTapNextButton()
        sut.greenSecondSceneDidTapNextButton()

        // when
        sut.greenThirdSceneDidTapBackButton()

        // then
        XCTAssertEqual(sut.scenes, [.greenFirstScene, .greenSecondScene])
        XCTAssertEqual(sut.currentScene, .greenSecondScene)
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertEqual(
            navigatorSpy.log,
            [
                .continueFlow(source: .greenFirstScene, destination: .greenSecondScene),
                .continueFlow(source: .greenSecondScene, destination: .greenThirdScene),
                .goBackInFlow(source: .greenThirdScene, destination: nil),
            ]
        )
    }
    
}
