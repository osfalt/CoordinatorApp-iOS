//
//  NavigatorSpy.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import CoordinatorApp

class NavigatorSpy {
    
    enum MethodCall: Equatable {
        case newFlow(source: MockScene, destination: MockScene, style: NewFlowNavigationStyle)
        case continueFlow(source: MockScene, destination: MockScene)
        case completeFlow(scene: MockScene, style: CompleteFlowNavigationStyle)
        case goBackInFlow(source: MockScene, destination: MockScene?)
    }
    
    private(set) var log: [MethodCall] = []
    private(set) var navigator: Navigator<MockScene>!
    
    init() {
        navigator = .init(
            newFlow: { source, destination, style in
                self.log.append(.newFlow(source: source, destination: destination, style: style))
            },
            continueFlow: { source, destination in
                self.log.append(.continueFlow(source: source, destination: destination))
            },
            completeFlow: { scene, style in
                self.log.append(.completeFlow(scene: scene, style: style))
            },
            goBackInFlow: { source, destination in
                self.log.append(.goBackInFlow(source: source, destination: destination))
            }
        )
    }
    
}
