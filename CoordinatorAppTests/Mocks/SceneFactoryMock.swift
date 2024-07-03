//
//  SceneFactoryMock.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import CoordinatorApp

enum MockScene: Equatable {
    case rootScene
    case signInScene
    case signUpScene
    case mainTabBarScene
    case redFirstScene
    case redSecondScene
    case redDynamicInfoScene
    case greenFirstScene
    case greenSecondScene
    case greenThirdScene
    case settingsScene
    case profileDetails
}

struct SceneFactoryMock: SceneFactory {
    
    typealias Scene = MockScene
    
    func rootScene() -> Scene {
        .rootScene
    }
    
    func signInScene(delegate: SignInSceneOutputDelegate) -> Scene {
        .signInScene
    }
    
    func signUpScene(delegate: SignUpSceneOutputDelegate) -> Scene {
        .signUpScene
    }
    
    func mainTabBarScene() -> Scene {
        .mainTabBarScene
    }
    
    func redFirstScene(delegate: RedFirstSceneOutputDelegate) -> Scene {
        .redFirstScene
    }
    
    func redSecondScene(delegate: RedSecondSceneOutputDelegate) -> Scene {
        .redSecondScene
    }
    
    func redDynamicInfoScene(delegate: RedDynamicInfoSceneOutputDelegate) -> Scene {
        .redDynamicInfoScene
    }
    
    func greenFirstScene(delegate: GreenFirstSceneOutputDelegate) -> Scene {
        .greenFirstScene
    }
    
    func greenSecondScene(delegate: GreenSecondSceneOutputDelegate) -> Scene {
        .greenSecondScene
    }
    
    func greenThirdScene(text: String?, delegate: GreenThirdSceneOutputDelegate) -> Scene {
        .greenThirdScene
    }
    
    func settingsScene(delegate: SettingsSceneOutputDelegate) -> Scene {
        .settingsScene
    }
    
    func profileDetails(delegate: ProfileDetailsSceneOutputDelegate) -> MockScene {
        .profileDetails
    }
    
}
