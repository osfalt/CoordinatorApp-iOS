//
//  NavigatorSpy.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import CoordinatorApp

final class NavigatorSpy: Navigator {
    
    typealias Scene = MockScene
    
    enum MethodCall: Equatable {
        case newFlow(source: MockScene, destination: MockScene, style: NewFlowNavigationStyle)
        case continueFlow(source: MockScene, destination: MockScene)
        case completeFlow(scene: MockScene, style: CompleteFlowNavigationStyle)
        case goBackInFlow(source: MockScene, destination: MockScene?)
    }
    
    private(set) var log: [MethodCall] = []
    
    func newFlow(from source: Scene, to destination: Scene, style: NewFlowNavigationStyle) {
        log.append(.newFlow(source: source, destination: destination, style: style))
    }
    
    func continueFlow(from source: Scene, to destination: Scene) {
        log.append(.continueFlow(source: source, destination: destination))
    }
    
    func completeFlow(on scene: Scene, style: CompleteFlowNavigationStyle) {
        log.append(.completeFlow(scene: scene, style: style))
    }
    
    func goBackInFlow(to destination: Scene?, from source: Scene) {
        log.append(.goBackInFlow(source: source, destination: destination))
    }
    
}
