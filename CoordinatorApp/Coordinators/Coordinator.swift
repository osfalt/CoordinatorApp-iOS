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
    static let settingsItem = TabBarItem(title: "Settings Flow", imageName: "gear.circle.fill")
}

class Coordinator<Scene> {
    
    typealias Interactor = HasAuthorizationTokenStoring
    
    // MARK: - Public Properties
    
    private(set) var rootScenes: [Scene] = []
    private(set) var authorizationScenes: [Scene] = []
    private(set) var redFlowScenes: [Scene] = []
    private(set) var greenFlowScenes: [Scene] = []
    private(set) var settingsScenes: [Scene] = []
    
    var currentRootScene: Scene? { rootScenes.last }
    var currentAuthorizationScene: Scene? { authorizationScenes.last }
    var currentRedFlowScene: Scene? { redFlowScenes.last }
    var currentGreenFlowScene: Scene? { greenFlowScenes.last }
    var currentSettingsScene: Scene? { settingsScenes.last }
    
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
        let signInScene = factory.signInScene(delegate: self)
        navigator.newFlow(from: rootScene, to: signInScene, style: .embed(mode: .flow))
        rootScenes.append(signInScene)
        authorizationScenes.append(signInScene)
    }
    
    private func completeAuthorizationFlow() {
        guard let currentAuthorizationScene = currentAuthorizationScene else { return }
        navigator.completeFlow(on: currentAuthorizationScene, style: .unembed)
        authorizationScenes = []
        rootScenes.removeLast()
    }
    
    private func startMainFlow(on rootScene: Scene) {
        let tabBarScene = factory.mainTabBarScene()
        navigator.newFlow(from: rootScene, to: tabBarScene, style: .embed(mode: .single))
        rootScenes.append(tabBarScene)
        
        let redFirstScene = factory.redFirstScene(delegate: self)
        navigator.newFlow(from: tabBarScene, to: redFirstScene, style: .tabBar(.redFlowItem))
        redFlowScenes.append(redFirstScene)
        
        let greenFirstScene = factory.greenFirstScene(delegate: self)
        navigator.newFlow(from: tabBarScene, to: greenFirstScene, style: .tabBar(.greenFlowItem))
        greenFlowScenes.append(greenFirstScene)
        
        let settingsScene = factory.settingsScene(delegate: self)
        navigator.newFlow(from: tabBarScene, to: settingsScene, style: .tabBar(.settingsItem))
        settingsScenes.append(settingsScene)
    }
    
    private func completeMainFlow() {
        guard let rootScene = currentRootScene else { return }
        navigator.completeFlow(on: rootScene, style: .unembed)
        
        redFlowScenes = []
        greenFlowScenes = []
        settingsScenes = []
        rootScenes.removeLast()
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

extension Coordinator: SignInSceneOutputDelegate {
    
    func signInSceneDidLogInSuccessfully() {
        completeAuthorizationFlow()
        
        guard let rootScene = currentRootScene else { return }
        startMainFlow(on: rootScene)
    }
    
    func signInSceneDidTapCreateAccountButton() {
        guard let currentAuthorizationScene = currentAuthorizationScene else { return }
        let signUpScene = factory.signUpScene(delegate: self)
        navigator.continueFlow(from: currentAuthorizationScene, to: signUpScene)
        authorizationScenes.append(signUpScene)
    }
    
}

extension Coordinator: SignUpSceneOutputDelegate {
    
    func signUpSceneDidRegisterSuccessfully() {
        completeAuthorizationFlow()
        
        guard let rootScene = currentRootScene else { return }
        startMainFlow(on: rootScene)
    }
    
    func signUpSceneDidTapBackButton() {
        guard let currentAuthorizationScene = currentAuthorizationScene else { return }
        navigator.goBackInFlow(to: nil, from: currentAuthorizationScene)
        authorizationScenes.removeLast()
    }
    
}

extension Coordinator: RedFirstSceneOutputDelegate {
    
    func redFirstSceneDidTapNextButton() {
        pushSceneInRedFlow(factory.redSecondScene(delegate: self))
    }
    
}

extension Coordinator: RedSecondSceneOutputDelegate {
    
    func redSecondSceneDidTapNextButton() {
        pushSceneInRedFlow(factory.redDynamicInfoScene(delegate: self))
    }
    
    func redSecondSceneDidTapBackButton() {
        popSceneInRedFlow()
    }
    
}

extension Coordinator: RedDynamicInfoSceneOutputDelegate {
    
    func redDynamicInfoSceneDidSelectItem(_ item: RedDynamicInfoItem) {
        print("👀 redDynamicInfoSceneDidSelectItem: \(item)")
    }
    
    func redDynamicInfoSceneDidTapBackButton() {
        popSceneInRedFlow()
    }
    
}

extension Coordinator: GreenFirstSceneOutputDelegate {
    
    func greenFirstSceneDidTapNextButton() {
        pushSceneInGreenFlow(factory.greenSecondScene(delegate: self))
    }
    
}

extension Coordinator: GreenSecondSceneOutputDelegate {
    
    func greenSecondSceneDidTapNextButton() {
        pushSceneInGreenFlow(factory.greenThirdScene(text: nil, delegate: self))
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

extension Coordinator: SettingsSceneOutputDelegate {
    
    func settingsSceneDidLogoutSuccessfully() {
        completeMainFlow()
        
        guard let rootScene = currentRootScene else { return }
        startAuthorizationFlow(on: rootScene)
    }
    
}
