//
//  SceneFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

// MARK: - Interface

public class SceneFactory<Scene> {
    
    public let rootScene: () -> Scene
    public let signInScene: (SignInSceneOutputDelegate) -> Scene
    public let signUpScene: (SignUpSceneOutputDelegate) -> Scene
    public let mainTabBarScene: () -> Scene
    
    public let redFirstScene: (RedFirstSceneOutputDelegate) -> Scene
    public let redSecondScene: (RedSecondSceneOutputDelegate) -> Scene
    public let redDynamicInfoScene: (RedDynamicInfoSceneOutputDelegate) -> Scene
    
    public let greenFirstScene: (GreenFirstSceneOutputDelegate) -> Scene
    public let greenSecondScene: (GreenSecondSceneOutputDelegate) -> Scene
    public let greenThirdScene: (String?, GreenThirdSceneOutputDelegate) -> Scene
    
    public let settingsScene: (SettingsSceneOutputDelegate) -> Scene
    
    public init(
        rootScene: @escaping () -> Scene,
        signInScene: @escaping (SignInSceneOutputDelegate) -> Scene,
        signUpScene: @escaping (SignUpSceneOutputDelegate) -> Scene,
        mainTabBarScene: @escaping () -> Scene,
        redFirstScene: @escaping (RedFirstSceneOutputDelegate) -> Scene,
        redSecondScene: @escaping (RedSecondSceneOutputDelegate) -> Scene,
        redDynamicInfoScene: @escaping (RedDynamicInfoSceneOutputDelegate) -> Scene,
        greenFirstScene: @escaping (GreenFirstSceneOutputDelegate) -> Scene,
        greenSecondScene: @escaping (GreenSecondSceneOutputDelegate) -> Scene,
        greenThirdScene: @escaping (String?, GreenThirdSceneOutputDelegate) -> Scene,
        settingsScene: @escaping (SettingsSceneOutputDelegate) -> Scene
    ) {
        self.rootScene = rootScene
        self.signInScene = signInScene
        self.signUpScene = signUpScene
        self.mainTabBarScene = mainTabBarScene
        self.redFirstScene = redFirstScene
        self.redSecondScene = redSecondScene
        self.redDynamicInfoScene = redDynamicInfoScene
        self.greenFirstScene = greenFirstScene
        self.greenSecondScene = greenSecondScene
        self.greenThirdScene = greenThirdScene
        self.settingsScene = settingsScene
    }
    
}

// MARK: - Implementation

extension SceneFactory {
    
    static func make(with dependencies: Dependencies) -> SceneFactory<UIViewController> {
        SceneFactory<UIViewController>(
            rootScene: {
                let rootViewController = RootViewController()
                return rootViewController
            },
            signInScene: { outputDelegate in
                let viewModel = SignInViewModel(interactor: dependencies, outputDelegate: outputDelegate)
                let viewController = SignInViewController(viewModel: viewModel)
                return viewController
            },
            signUpScene: { outputDelegate in
                let viewModel = SignUpViewModel(interactor: dependencies, outputDelegate: outputDelegate)
                let viewController = SignUpViewController(viewModel: viewModel)
                return viewController
            },
            mainTabBarScene: {
                let tabBarController = UITabBarController()
                tabBarController.view.backgroundColor = .lightGray
                return tabBarController
            },
            redFirstScene: { outputDelegate in
                let viewModel = RedFirstViewModel(outputDelegate: outputDelegate)
                let viewController = RedFirstViewController(viewModel: viewModel)
                return viewController
            },
            redSecondScene: { outputDelegate in
                let viewModel = RedSecondViewModel(outputDelegate: outputDelegate)
                let viewController = RedSecondViewController(viewModel: viewModel)
                return viewController
            },
            redDynamicInfoScene: { outputDelegate in
                let viewModel = RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher(), outputDelegate: outputDelegate)
                let viewController = RedDynamicInfoViewController(viewModel: viewModel)
                return viewController
            },
            greenFirstScene: { outputDelegate in
                let viewModel = GreenFirstViewModel(outputDelegate: outputDelegate)
                let viewController = GreenFirstViewController(viewModel: viewModel)
                return viewController
            },
            greenSecondScene: { outputDelegate in
                let viewModel = GreenSecondViewModel(outputDelegate: outputDelegate)
                let viewController = GreenSecondViewController(viewModel: viewModel)
                return viewController
            },
            greenThirdScene: { dynamicText, outputDelegate in
                let viewModel = GreenThirdViewModel(dynamicText: dynamicText, outputDelegate: outputDelegate)
                let viewController = GreenThirdViewController(viewModel: viewModel)
                return viewController
            },
            settingsScene: { outputDelegate in
                let viewModel = SettingsViewModel(interactor: dependencies, outputDelegate: outputDelegate)
                let viewController = SettingsViewController(viewModel: viewModel)
                return viewController
            }
        )
    }
    
}
