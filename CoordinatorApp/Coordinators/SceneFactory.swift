//
//  SceneFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

// MARK: - Interface

class SceneFactory<Scene> {
    
    let rootScene: () -> Scene
    let mainTabBarScene: () -> Scene
    
    let redFirstScene: (RedFirstSceneOutputDelegate) -> Scene
    let redSecondScene: (RedSecondSceneOutputDelegate) -> Scene
    let redDynamicInfoScene: (RedDynamicInfoSceneOutputDelegate) -> Scene
    
    let greenFirstScene: (GreenFirstSceneOutputDelegate) -> Scene
    let greenSecondScene: (GreenSecondSceneOutputDelegate) -> Scene
    let greenThirdScene: (String?, GreenThirdSceneOutputDelegate) -> Scene
    
    init(
        rootScene: @escaping () -> Scene,
        mainTabBarScene: @escaping () -> Scene,
        redFirstScene: @escaping (RedFirstSceneOutputDelegate) -> Scene,
        redSecondScene: @escaping (RedSecondSceneOutputDelegate) -> Scene,
        redDynamicInfoScene: @escaping (RedDynamicInfoSceneOutputDelegate) -> Scene,
        greenFirstScene: @escaping (GreenFirstSceneOutputDelegate) -> Scene,
        greenSecondScene: @escaping (GreenSecondSceneOutputDelegate) -> Scene,
        greenThirdScene: @escaping (String?, GreenThirdSceneOutputDelegate) -> Scene
    ) {
        self.rootScene = rootScene
        self.mainTabBarScene = mainTabBarScene
        self.redFirstScene = redFirstScene
        self.redSecondScene = redSecondScene
        self.redDynamicInfoScene = redDynamicInfoScene
        self.greenFirstScene = greenFirstScene
        self.greenSecondScene = greenSecondScene
        self.greenThirdScene = greenThirdScene
    }
    
}

// MARK: - Implementation

extension SceneFactory {
    
    static func make() -> SceneFactory<UIViewController> {
        SceneFactory<UIViewController>(
            rootScene: {
                let rootViewController = RootViewController()
                return rootViewController
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
            }
        )
    }
    
}
