//
//  Navigator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

enum NewFlowNavigationStyle {
    
    enum Mode {
        case flow
        case single
    }
    
    case modal(mode: Mode)
    case embed(mode: Mode)
    case tabBar
}

struct Navigator<Scene> {
    
    let newFlow: (_ source: Scene, _ destination: Scene, _ style: NewFlowNavigationStyle) -> Void
    let continueFlow: (_ source: Scene, _ destination: Scene) -> Void
    let completeFlow: (_ scene: Scene) -> Void
    let goBackInFlow: (_ source: Scene, _ destination: Scene?) -> Void
    
    init(
        newFlow: @escaping (_ source: Scene, _ destination: Scene, _ style: NewFlowNavigationStyle) -> Void,
        continueFlow: @escaping (_ source: Scene, _ destination: Scene) -> Void,
        completeFlow: @escaping (_ scene: Scene) -> Void,
        goBackInFlow: @escaping (_ source: Scene, _ destination: Scene?) -> Void
    ) {
        self.newFlow = newFlow
        self.continueFlow = continueFlow
        self.completeFlow = completeFlow
        self.goBackInFlow = goBackInFlow
    }
    
    func newFlow(from source: Scene, to destination: Scene, style: NewFlowNavigationStyle) {
        newFlow(source, destination, style)
    }
    
    func continueFlow(from source: Scene, to destination: Scene) {
        continueFlow(source, destination)
    }

    func completeFlow(on scene: Scene) {
        completeFlow(scene)
    }
    
    func goBackInFlow(to destination: Scene?, from source: Scene) {
        goBackInFlow(source, destination)
    }
    
}

extension Navigator {
    
    static func make(animatedTransitions: Bool = UIView.areAnimationsEnabled) -> Navigator<UIViewController> {
        Navigator<UIViewController>(
            newFlow: { source, destination, style in
                switch style {
                case .modal(let mode):
                    var presentedScene = destination
                    if mode == .flow {
                        presentedScene = BaseNavigationController(rootViewController: destination)
                    }
                    source.present(presentedScene, animated: animatedTransitions)
                    
                case .embed(let mode):
                    var embededScene = destination
                    if mode == .flow {
                        embededScene = BaseNavigationController(rootViewController: destination)
                    }
                    source.embed(embededScene)
                    
                case .tabBar where source is UITabBarController:
                    let navigationController = BaseNavigationController(rootViewController: destination)
                    source.addChild(navigationController)
                    
                default:
                    fatalError("Unsupported combination of source: \(source), destination: \(destination), style: \(style)")
                }
            },
            continueFlow: { source, destination in
                source.navigationController?.pushViewController(destination, animated: animatedTransitions)
            },
            completeFlow: { scene in
                scene.dismiss(animated: animatedTransitions)
            },
            goBackInFlow: { source, destination in
                if let destination = destination {
                    source.navigationController?.popToViewController(destination, animated: animatedTransitions)
                } else {
                    source.navigationController?.popViewController(animated: animatedTransitions)
                }
            }
        )
    }
    
}
