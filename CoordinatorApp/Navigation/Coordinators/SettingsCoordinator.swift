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

#warning("TODO: add presenting modal scene from here")
final class SettingsCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    var currentScene: Scene? { scenes.last }
    private(set) var scenes: [Scene] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private var children: [any Coordinator] = []
    private weak var delegate: SettingsCoordinatorDelegate?
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, delegate: SettingsCoordinatorDelegate) {
        self.navigator = navigator
        self.factory = factory
        self.delegate = delegate
    }
    
    // MARK: - Coordinator Protocol
    
    @discardableResult
    func start() -> Scene {
        let settingsScene = factory.settingsScene(delegate: self)
        scenes.append(settingsScene)
        return settingsScene
    }
    
}

// MARK: - Scene Outputs

extension SettingsCoordinator: SettingsSceneOutputDelegate {
    
    func settingsSceneDidLogoutSuccessfully() {
        delegate?.settingsCoordinatorDidFinish()
    }
    
}
