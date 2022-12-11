//
//  Coordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

extension TabBarItem {
    
    static let redFlowItem = TabBarItem(title: "Red Flow", imageName: "house.circle.fill")
    static let greenFlowItem = TabBarItem(title: "Green Flow", imageName: "book.circle.fill")
    
}

class Coordinator<Scene> {
    
    // MARK: - Public
    
    private(set) var rootScenes: [Scene] = []
    private(set) var redFlowScenes: [Scene] = []
    private(set) var greenFlowScenes: [Scene] = []
    
    var currentRootScene: Scene? { rootScenes.last }
    var currentRedFlowScene: Scene? { redFlowScenes.last }
    var currentGreenFlowScene: Scene? { greenFlowScenes.last }
    
    // MARK: - Private
    
    private let navigator: Navigator<Scene>
    private let factory: SceneFactory<Scene>
    
    // MARK: - Init
    
    init(navigator: Navigator<Scene>, factory: SceneFactory<Scene>) {
        self.navigator = navigator
        self.factory = factory
    }
    
    @discardableResult
    func start() -> Scene {
        let rootScene = factory.rootScene()
        let tabBarScene = factory.mainTabBarScene()
        navigator.newFlow(from: rootScene, to: tabBarScene, style: .embed(mode: .single))
        rootScenes += [rootScene, tabBarScene]
        
        let redFirstScene = factory.redFirstScene(self)
        navigator.newFlow(from: tabBarScene, to: redFirstScene, style: .tabBar(.redFlowItem))
        redFlowScenes.append(redFirstScene)
        
        let greenFirstScene = factory.greenFirstScene(self)
        navigator.newFlow(from: tabBarScene, to: greenFirstScene, style: .tabBar(.greenFlowItem))
        greenFlowScenes.append(greenFirstScene)
        
        return rootScene
    }
    
    private func pushSceneInRedFlow(_ scene: Scene) {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        navigator.continueFlow(from: currentRedFlowScene, to: scene)
        redFlowScenes.append(scene)
    }
    
    private func popSceneInRedFlow() {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        navigator.goBackInFlow(to: nil, from: currentRedFlowScene)
        redFlowScenes.removeLast()
    }
    
    private func pushSceneInGreenFlow(_ scene: Scene) {
        guard let currentGreenFlowScene = currentGreenFlowScene else { return }
        navigator.continueFlow(from: currentGreenFlowScene, to: scene)
        greenFlowScenes.append(scene)
    }
    
    private func popSceneInGreenFlow() {
        guard let currentGreenFlowScene = currentGreenFlowScene else { return }
        navigator.goBackInFlow(to: nil, from: currentGreenFlowScene)
        greenFlowScenes.removeLast()
    }
    
}

// MARK: - Scenes Outputs

extension Coordinator: RedFirstSceneOutputDelegate {
    
    func redFirstSceneDidTapNextButton() {
        pushSceneInRedFlow(factory.redSecondScene(self))
    }
    
}

extension Coordinator: RedSecondSceneOutputDelegate {
    
    func redSecondSceneDidTapNextButton() {
        pushSceneInRedFlow(factory.redDynamicInfoScene(self))
    }
    
    func redSecondSceneDidTapBackButton() {
        popSceneInRedFlow()
    }
    
}

extension Coordinator: RedDynamicInfoSceneOutputDelegate {
    
    func redDynamicInfoSceneDidSelectItem(_ item: Item) {
        print("👀 redDynamicInfoSceneDidSelectItem: \(item)")
    }
    
    func redDynamicInfoSceneDidTapBackButton() {
        popSceneInRedFlow()
    }
    
}

extension Coordinator: GreenFirstSceneOutputDelegate {
    
    func greenFirstSceneDidTapNextButton() {
        pushSceneInGreenFlow(factory.greenSecondScene(self))
    }
    
}

extension Coordinator: GreenSecondSceneOutputDelegate {
    
    func greenSecondSceneDidTapNextButton() {
        pushSceneInGreenFlow(factory.greenThirdScene(nil, self))
    }
    
    func greenSecondSceneDidTapBackButton() {
        popSceneInGreenFlow()
    }
    
}

extension Coordinator: GreenThirdSceneOutputDelegate {
    
    func greenThirdSceneDidTapNextButton() {
        print("👀 greenThirdSceneDidTapBackButton")
    }
    
    func greenThirdSceneDidTapBackButton() {
        popSceneInGreenFlow()
    }
    
}
