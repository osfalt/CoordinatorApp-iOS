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
}

extension SceneFactory {
    
    static func mock() -> SceneFactory<MockScene> {
        SceneFactory<MockScene>(
            rootScene: { .rootScene },
            signInScene: { _ in .signInScene },
            signUpScene: { _ in .signUpScene },
            mainTabBarScene: { .mainTabBarScene },
            redFirstScene: { _ in .redFirstScene },
            redSecondScene: { _ in .redSecondScene },
            redDynamicInfoScene: { _ in .redDynamicInfoScene },
            greenFirstScene: { _ in .greenFirstScene },
            greenSecondScene: { _ in .greenSecondScene },
            greenThirdScene: { _, _ in .greenThirdScene }
        )
    }
    
}
