//
//  MainTabBarCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

extension TabBarItem {
    static let redFlowItem = TabBarItem(title: "Red Flow", imageName: "house.circle.fill")
    static let greenFlowItem = TabBarItem(title: "Green Flow", imageName: "book.circle.fill")
    static let settingsItem = TabBarItem(title: "Settings Flow", imageName: "gear.circle.fill")
}

protocol MainTabBarCoordinatorDelegate: AnyObject {
    func mainTabBarCoordinatorDidFinish()
}

final class MainTabBarCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    private(set) var scenes: [Scene] = []
    private(set) var children: [any Coordinator] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private weak var delegate: MainTabBarCoordinatorDelegate?
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, delegate: MainTabBarCoordinatorDelegate) {
        self.navigator = navigator
        self.factory = factory
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func start() -> Scene {
        let tabBarScene = factory.mainTabBarScene()
        scenes.append(tabBarScene)
        
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
        
        return tabBarScene
    }
    
}

// MARK: - Child Coordinator Delegates

extension MainTabBarCoordinator: SettingsCoordinatorDelegate {
    
    func settingsCoordinatorDidFinish() {
        delegate?.mainTabBarCoordinatorDidFinish()
    }
    
}
