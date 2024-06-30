//
//  AuthorizationCoordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

protocol AuthorizationCoordinatorDelegate: AnyObject {
    func authorizationCoordinatorDidFinish()
}

final class AuthorizationCoordinator<Scene>: Coordinator {
    
    // MARK: - Public Properties
    
    var currentScene: Scene? { scenes.last }
    private(set) var scenes: [Scene] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private var children: [any Coordinator] = []
    private weak var delegate: AuthorizationCoordinatorDelegate?
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, delegate: AuthorizationCoordinatorDelegate) {
        self.navigator = navigator
        self.factory = factory
        self.delegate = delegate
    }
    
    // MARK: - Coordinator Protocol
    
    @discardableResult
    func start() -> Scene {
        let signInScene = factory.signInScene(delegate: self)
        scenes.append(signInScene)
        return signInScene
    }
    
    // MARK: - Private Methods
    
    private func completeFlow() {
        guard let currentScene = currentScene else { return }
        navigator.completeFlow(on: currentScene, style: .unembed)
        scenes.removeLast()
    }
    
}

// MARK: - Scene Outputs

extension AuthorizationCoordinator: SignInSceneOutputDelegate {
    
    func signInSceneDidLogInSuccessfully() {
        completeFlow()
        delegate?.authorizationCoordinatorDidFinish()
    }
    
    func signInSceneDidTapCreateAccountButton() {
        guard let currentScene = currentScene else { return }
        let signUpScene = factory.signUpScene(delegate: self)
        navigator.continueFlow(from: currentScene, to: signUpScene)
        scenes.append(signUpScene)
    }
    
}

extension AuthorizationCoordinator: SignUpSceneOutputDelegate {
    
    func signUpSceneDidRegisterSuccessfully() {
        completeFlow()
        delegate?.authorizationCoordinatorDidFinish()
    }
    
    func signUpSceneDidTapBackButton() {
        guard let currentScene = currentScene else { return }
        navigator.goBackInFlow(to: nil, from: currentScene)
        scenes.removeLast()
    }
    
}
