//
//  CoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 10/12/2022.
//

import XCTest
@testable import CoordinatorApp

final class CoordinatorTests: XCTestCase {
    
    private var mockNavigatorWrapper: MockNavigatorWrapper!
    private var factory: SceneFactory<MockScene>!
    private var sut: Coordinator<MockScene>!

    override func setUp() {
        super.setUp()
        
        mockNavigatorWrapper = MockNavigatorWrapper()
        factory = SceneFactory<MockScene>.mock()
        sut = Coordinator(navigator: mockNavigatorWrapper.navigator, factory: factory)
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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
            mockNavigatorWrapper.log,
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

// MARK: - Mocks

enum MockScene: Equatable {
    case rootScene
    case mainTabBarScene
    case redFirstScene
    case redSecondScene
    case redDynamicInfoScene
    case greenFirstScene
    case greenSecondScene
    case greenThirdScene
}

class MockNavigatorWrapper {
    
    enum MethodCall: Equatable {
        case newFlow(source: MockScene, destination: MockScene, style: NewFlowNavigationStyle)
        case continueFlow(source: MockScene, destination: MockScene)
        case completeFlow(scene: MockScene)
        case goBackInFlow(source: MockScene, destination: MockScene?)
    }
    
    private(set) var log: [MethodCall] = []
    private(set) var navigator: Navigator<MockScene>!
    
    init() {
        navigator = .init(
            newFlow: { source, destination, style in
                self.log.append(.newFlow(source: source, destination: destination, style: style))
            },
            continueFlow: { source, destination in
                self.log.append(.continueFlow(source: source, destination: destination))
            },
            completeFlow: { scene in
                self.log.append(.completeFlow(scene: scene))
            },
            goBackInFlow: { source, destination in
                self.log.append(.goBackInFlow(source: source, destination: destination))
            }
        )
    }
    
}

extension SceneFactory {
    
    static func mock() -> SceneFactory<MockScene> {
        SceneFactory<MockScene>(
            rootScene: { .rootScene },
            mainTabBarScene: { .mainTabBarScene },
            redFirstScene: { delegate in .redFirstScene },
            redSecondScene: { delegate in .redSecondScene },
            redDynamicInfoScene: { delegate in .redDynamicInfoScene },
            greenFirstScene: { delegate in .greenFirstScene },
            greenSecondScene: { delegate in .greenSecondScene },
            greenThirdScene: { text, delegate in .greenThirdScene }
        )
    }
    
}
