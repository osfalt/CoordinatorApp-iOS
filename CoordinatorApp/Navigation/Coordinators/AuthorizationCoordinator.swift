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
    
    private(set) var scenes: [Scene] = []
    private(set) var children: [any Coordinator] = []
    
    // MARK: - Private Properties
    
    private let navigator: any Navigator<Scene>
    private let factory: any SceneFactory<Scene>
    private weak var delegate: AuthorizationCoordinatorDelegate?
    
    // MARK: - Init
    
    init(navigator: any Navigator<Scene>, factory: any SceneFactory<Scene>, delegate: AuthorizationCoordinatorDelegate) {
        self.navigator = navigator
        self.factory = factory
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func start() -> Scene {
        let signInScene = factory.signInScene(delegate: self)
        scenes.append(signInScene)
        return signInScene
    }
    
}

// MARK: - Scene Outputs

extension AuthorizationCoordinator: SignInSceneOutputDelegate {
    
    func signInSceneDidLogInSuccessfully() {
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
        delegate?.authorizationCoordinatorDidFinish()
    }
    
    func signUpSceneDidTapBackButton() {
        guard let currentScene = currentScene else { return }
        navigator.goBackInFlow(to: nil, from: currentScene)
        scenes.removeLast()
    }
    
}
