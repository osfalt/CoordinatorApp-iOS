//
//  RedFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

final class RedFlowCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    private(set) var scenes: [Scene] = []
    private(set) var children: [any Coordinator] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>) {
        self.navigator = navigator
        self.factory = factory
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func start() -> Scene {
        let redFirstScene = factory.redFirstScene(delegate: self)
        scenes.append(redFirstScene)
        return redFirstScene
    }
    
    // MARK: - Private Methods
    
    private func pushScene(_ scene: Scene) {
        guard let currentScene = currentScene else { return }
        navigator.continueFlow(from: currentScene, to: scene)
        scenes.append(scene)
    }
    
    private func popScene() {
        guard let currentScene = currentScene else { return }
        navigator.goBackInFlow(to: nil, from: currentScene)
        scenes.removeLast()
    }
    
}

// MARK: - Scene Outputs

extension RedFlowCoordinator: RedFirstSceneOutputDelegate {
    
    func redFirstSceneDidTapNextButton() {
        pushScene(factory.redSecondScene(delegate: self))
    }
    
}

extension RedFlowCoordinator: RedSecondSceneOutputDelegate {
    
    func redSecondSceneDidTapNextButton() {
        pushScene(factory.redDynamicInfoScene(delegate: self))
    }
    
    func redSecondSceneDidTapBackButton() {
        popScene()
    }
    
}

extension RedFlowCoordinator: RedDynamicInfoSceneOutputDelegate {
    
    func redDynamicInfoSceneDidSelectItem(_ item: RedDynamicInfoItem) {
        print("👀 redDynamicInfoSceneDidSelectItem: \(item)")
    }
    
    func redDynamicInfoSceneDidTapBackButton() {
        popScene()
    }
    
}
