//
//  SceneFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

// MARK: - Interface

public protocol SceneFactory<Scene> {
    
    associatedtype Scene
    
    func rootScene() -> Scene
    func signInScene(delegate: SignInSceneOutputDelegate) -> Scene
    func signUpScene(delegate: SignUpSceneOutputDelegate) -> Scene
    func mainTabBarScene() -> Scene
    
    func redFirstScene(delegate: RedFirstSceneOutputDelegate) -> Scene
    func redSecondScene(delegate: RedSecondSceneOutputDelegate) -> Scene
    func redDynamicInfoScene(delegate: RedDynamicInfoSceneOutputDelegate) -> Scene
    
    func greenFirstScene(delegate: GreenFirstSceneOutputDelegate) -> Scene
    func greenSecondScene(delegate: GreenSecondSceneOutputDelegate) -> Scene
    func greenThirdScene(text: String?, delegate: GreenThirdSceneOutputDelegate) -> Scene
    
    func settingsScene(delegate: SettingsSceneOutputDelegate) -> Scene
    
}

// MARK: - Implementation

struct ViewControllerSceneFactory: SceneFactory {
    
    typealias Scene = UIViewController
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func rootScene() -> Scene {
        RootViewController()
    }
    
    func signInScene(delegate: SignInSceneOutputDelegate) -> Scene {
        let viewModel = SignInViewModel(interactor: dependencies, outputDelegate: delegate)
        let viewController = SignInViewController(viewModel: viewModel)
        return viewController
    }
    
    func signUpScene(delegate: SignUpSceneOutputDelegate) -> Scene {
        let viewModel = SignUpViewModel(interactor: dependencies, outputDelegate: delegate)
        let viewController = SignUpViewController(viewModel: viewModel)
        return viewController
    }
    
    func mainTabBarScene() -> Scene {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .lightGray
        return tabBarController
    }
    
    func redFirstScene(delegate: RedFirstSceneOutputDelegate) -> Scene {
        let viewModel = RedFirstViewModel(outputDelegate: delegate)
        let viewController = RedFirstViewController(viewModel: viewModel)
        return viewController
    }
    
    func redSecondScene(delegate: RedSecondSceneOutputDelegate) -> Scene {
        let viewModel = RedSecondViewModel(outputDelegate: delegate)
        let viewController = RedSecondViewController(viewModel: viewModel)
        return viewController
    }
    
    func redDynamicInfoScene(delegate: RedDynamicInfoSceneOutputDelegate) -> Scene {
        let viewModel = RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher(), outputDelegate: delegate)
        let viewController = RedDynamicInfoViewController(viewModel: viewModel)
        return viewController
    }
    
    func greenFirstScene(delegate: GreenFirstSceneOutputDelegate) -> Scene {
        let viewModel = GreenFirstViewModel(outputDelegate: delegate)
        let viewController = GreenFirstViewController(viewModel: viewModel)
        return viewController
    }
    
    func greenSecondScene(delegate: GreenSecondSceneOutputDelegate) -> Scene {
        let viewModel = GreenSecondViewModel(outputDelegate: delegate)
        let viewController = GreenSecondViewController(viewModel: viewModel)
        return viewController
    }
    
    func greenThirdScene(text: String?, delegate: GreenThirdSceneOutputDelegate) -> Scene {
        let viewModel = GreenThirdViewModel(dynamicText: text, outputDelegate: delegate)
        let viewController = GreenThirdViewController(viewModel: viewModel)
        return viewController
    }
    
    func settingsScene(delegate: SettingsSceneOutputDelegate) -> Scene {
        let viewModel = SettingsViewModel(interactor: dependencies, outputDelegate: delegate)
        let viewController = SettingsViewController(viewModel: viewModel)
        return viewController
    }
    
}
