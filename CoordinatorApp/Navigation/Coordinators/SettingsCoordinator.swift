//
//  SettingsCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

protocol SettingsCoordinatorDelegate: AnyObject {
    func settingsCoordinatorDidFinish()
}

final class SettingsCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    private(set) var scenes: [Scene] = []
    private(set) var children: [any Coordinator] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private weak var delegate: SettingsCoordinatorDelegate?
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, delegate: SettingsCoordinatorDelegate) {
        self.navigator = navigator
        self.factory = factory
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func start() -> Scene {
        let settingsScene = factory.settingsScene(delegate: self)
        scenes.append(settingsScene)
        return settingsScene
    }
    
}

// MARK: - Scene Outputs

extension SettingsCoordinator: SettingsSceneOutputDelegate {
    
    func settingsSceneDidTapProfileDetails() {
        guard let currentScene else { return }
        let profileDetailsScene = factory.profileDetails(delegate: self)
        navigator.newFlow(from: currentScene, to: profileDetailsScene, style: .modal(mode: .single))
        scenes.append(profileDetailsScene)
    }
    
    func settingsSceneDidLogoutSuccessfully() {
        delegate?.settingsCoordinatorDidFinish()
    }
    
}

extension SettingsCoordinator: ProfileDetailsSceneOutputDelegate {
    
    func profileDetailsSceneDidTapCloseButton() {
        guard let currentScene else { return }
        navigator.completeFlow(on: currentScene, style: .dismissModal)
        scenes.removeLast()
    }
    
}
