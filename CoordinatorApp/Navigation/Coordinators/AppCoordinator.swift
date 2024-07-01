//
//  AppCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation

final class AppCoordinator<Scene>: Coordinator {
    
    typealias Interactor = HasAuthorizationTokenStoring
    
    // MARK: - Public Properties
    
    private(set) var scenes: [Scene] = []
    private(set) var children: [any Coordinator] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private let interactor: Interactor
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, interactor: Interactor) {
        self.navigator = navigator
        self.factory = factory
        self.interactor = interactor
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func start() -> Scene {
        let rootScene = factory.rootScene()
        scenes.append(rootScene)
        
        if interactor.authorizationTokenStore.token == nil {
            startAuthorizationFlow(on: rootScene)
        } else {
            startMainFlow(on: rootScene)
        }
        
        return rootScene
    }
    
    // MARK: - Private Methods
    
    private func startAuthorizationFlow(on rootScene: Scene) {
        let authorizationCoordinator = AuthorizationCoordinator(navigator: navigator, factory: factory, delegate: self)
        let signInScene = authorizationCoordinator.start()
        navigator.newFlow(from: rootScene, to: signInScene, style: .embed(mode: .flow))
        children.append(authorizationCoordinator)
    }
    
    private func startMainFlow(on rootScene: Scene) {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigator: navigator, factory: factory, delegate: self)
        let tabBarScene = mainTabBarCoordinator.start()
        navigator.newFlow(from: rootScene, to: tabBarScene, style: .embed(mode: .single))
        children.append(mainTabBarCoordinator)
    }
    
}

// MARK: - Child Coordinator Delegates

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    
    func authorizationCoordinatorDidFinish() {
        guard let currentScene else { return }
        children.removeAll(where: { $0 is AuthorizationCoordinator<Scene> })
        startMainFlow(on: currentScene)
    }
    
}

extension AppCoordinator: MainTabBarCoordinatorDelegate {
    
    func mainTabBarCoordinatorDidFinish() {
        guard let currentScene else { return }
        children.removeAll(where: { $0 is MainTabBarCoordinator<Scene> })
        startAuthorizationFlow(on: currentScene)
    }
    
}
