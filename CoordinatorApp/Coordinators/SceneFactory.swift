//
//  SceneFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

class SceneFactory<Scene> {
    
    let rootScene: () -> Scene
    let mainTabBarScene: () -> Scene
    let redFirstScene: (RedFirstSceneOutputDelegate) -> Scene
    let redSecondScene: (RedSecondSceneOutputDelegate) -> Scene
    let redDynamicInfoScene: (RedDynamicInfoSceneOutputDelegate) -> Scene
    
    init(
        rootScene: @escaping () -> Scene,
        mainTabBarScene: @escaping () -> Scene,
        redFirstScene: @escaping (RedFirstSceneOutputDelegate) -> Scene,
        redSecondScene: @escaping (RedSecondSceneOutputDelegate) -> Scene,
        redDynamicInfoScene: @escaping (RedDynamicInfoSceneOutputDelegate) -> Scene
    ) {
        self.rootScene = rootScene
        self.mainTabBarScene = mainTabBarScene
        self.redFirstScene = redFirstScene
        self.redSecondScene = redSecondScene
        self.redDynamicInfoScene = redDynamicInfoScene
    }
    
}

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
            }
        )
    }
    
}
