//
//  Coordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

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
    
    func start() -> Scene {
        let rootScene = factory.rootScene()
        let tabBarScene = factory.mainTabBarScene()
        let redFirstScene = factory.redFirstScene(self)
        
        navigator.newFlow(from: rootScene, to: tabBarScene, style: .embed(mode: .single))
        navigator.newFlow(from: tabBarScene, to: redFirstScene, style: .tabBar)
                        
        rootScenes += [rootScene, tabBarScene]
        redFlowScenes.append(redFirstScene)
        
        return rootScene
    }
    
}

// MARK: - Scenes Outputs

extension Coordinator: RedFirstSceneOutputDelegate {
    
    func redFirstSceneDidTapNextButton() {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        
        let redSecondScene = factory.redSecondScene(self)
        navigator.continueFlow(from: currentRedFlowScene, to: redSecondScene)
        redFlowScenes.append(redSecondScene)
    }

}

extension Coordinator: RedSecondSceneOutputDelegate {
    
    func redSecondSceneDidTapNextButton() {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        
        let redDynamicInfoScene = factory.redDynamicInfoScene(self)
        navigator.continueFlow(from: currentRedFlowScene, to: redDynamicInfoScene)
        redFlowScenes.append(redDynamicInfoScene)
    }
    
    func redSecondSceneDidTapBackButton() {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        
        navigator.goBackInFlow(to: nil, from: currentRedFlowScene)
        redFlowScenes.removeLast()
    }
    
}

extension Coordinator: RedDynamicInfoSceneOutputDelegate {
    
    func redDynamicInfoSceneDidSelectItem(_ item: Item) {
        print("👀 redDynamicInfoSceneDidSelectItem: \(item)")
    }
    
    func redDynamicInfoSceneDidTapBackButton() {
        guard let currentRedFlowScene = currentRedFlowScene else { return }
        
        navigator.goBackInFlow(to: nil, from: currentRedFlowScene)
        redFlowScenes.removeLast()
    }
    
}
