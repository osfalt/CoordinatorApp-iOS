//
//  GreenFlowCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

final class GreenFlowCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    var currentScene: Scene? { scenes.last }
    private(set) var scenes: [Scene] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private var children: [any Coordinator] = []
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>) {
        self.navigator = navigator
        self.factory = factory
    }
    
    @discardableResult
    func start() -> Scene {
        let greenFirstScene = factory.greenFirstScene(delegate: self)
        scenes.append(greenFirstScene)
        return greenFirstScene
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

extension GreenFlowCoordinator: GreenFirstSceneOutputDelegate {
    
    func greenFirstSceneDidTapNextButton() {
        pushScene(factory.greenSecondScene(delegate: self))
    }
    
}

extension GreenFlowCoordinator: GreenSecondSceneOutputDelegate {
    
    func greenSecondSceneDidTapNextButton() {
        pushScene(factory.greenThirdScene(text: nil, delegate: self))
    }
    
    func greenSecondSceneDidTapBackButton() {
        popScene()
    }
    
}

extension GreenFlowCoordinator: GreenThirdSceneOutputDelegate {
    
    func greenThirdSceneDidTapNextButton() {
        print("👀 greenThirdSceneDidTapBackButton")
    }
    
    func greenThirdSceneDidTapBackButton() {
        popScene()
    }
    
}
