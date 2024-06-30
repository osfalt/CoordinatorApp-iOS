//
//  AppCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation

extension TabBarItem {
    static let redFlowItem = TabBarItem(title: "Red Flow", imageName: "house.circle.fill")
    static let greenFlowItem = TabBarItem(title: "Green Flow", imageName: "book.circle.fill")
    static let settingsItem = TabBarItem(title: "Settings Flow", imageName: "gear.circle.fill")
}

final class AppCoordinator<Scene>: Coordinator {
    
    typealias Interactor = HasAuthorizationTokenStoring
    
    // MARK: - Public Properties
    
    private(set) var rootScenes: [Scene] = []
    var currentRootScene: Scene? { rootScenes.last }
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private let interactor: Interactor
    private var children: [any Coordinator] = []
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, interactor: Interactor) {
        self.navigator = navigator
        self.factory = factory
        self.interactor = interactor
    }
    
    // MARK: - Coordinator Protocol
    
    @discardableResult
    func start() -> Scene {
        let rootScene = factory.rootScene()
        rootScenes.append(rootScene)
        
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
        let tabBarScene = factory.mainTabBarScene()
        navigator.newFlow(from: rootScene, to: tabBarScene, style: .embed(mode: .single))
        rootScenes.append(tabBarScene)
        
        let redFlowCoordinator = RedFlowCoordinator(navigator: navigator, factory: factory)
        let redFirstScene = redFlowCoordinator.start()
        navigator.newFlow(from: tabBarScene, to: redFirstScene, style: .tabBar(.redFlowItem))
        children.append(redFlowCoordinator)
        
        let greenFlowCoordinator = GreenFlowCoordinator(navigator: navigator, factory: factory)
        let greenFirstScene = greenFlowCoordinator.start()
        navigator.newFlow(from: tabBarScene, to: greenFirstScene, style: .tabBar(.greenFlowItem))
        children.append(greenFlowCoordinator)
        
        let settingsCoordinator = SettingsCoordinator(navigator: navigator, factory: factory, delegate: self)
        let settingsScene = settingsCoordinator.start()
        navigator.newFlow(from: tabBarScene, to: settingsScene, style: .tabBar(.settingsItem))
        children.append(settingsCoordinator)
    }
    
    private func completeMainFlow() {
        guard let rootScene = currentRootScene else { return }
        navigator.completeFlow(on: rootScene, style: .unembed)
        
        rootScenes.removeLast()
        children = []
    }
    
}

// MARK: - Child Coordinator Delegates

extension AppCoordinator: SettingsCoordinatorDelegate {
    
    func settingsCoordinatorDidFinish() {
        completeMainFlow()

        guard let rootScene = currentRootScene else { return }
        startAuthorizationFlow(on: rootScene)
    }
    
}

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    
    func authorizationCoordinatorDidFinish() {
        guard let rootScene = currentRootScene else { return }
        startMainFlow(on: rootScene)
    }
    
}
