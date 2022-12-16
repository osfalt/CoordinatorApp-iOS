//
//  Navigator.swift
//  CoordinatorApp
//
//  Created by Dre on 07/12/2022.
//

import Foundation
import UIKit

// MARK: - Models

public struct TabBarItem: Equatable {
    let title: String
    let imageName: String
}

public enum NewFlowNavigationStyle: Equatable {
    
    public enum Mode: Equatable {
        case flow
        case single
    }
    
    case modal(mode: Mode)
    case embed(mode: Mode)
    case tabBar(TabBarItem)
}

public enum CompleteFlowNavigationStyle: Equatable {
    case dismissModal
    case unembed
}

// MARK: - Interface

public protocol Navigator<Scene> {
    
    associatedtype Scene
    
    func newFlow(from source: Scene, to destination: Scene, style: NewFlowNavigationStyle)
    func continueFlow(from source: Scene, to destination: Scene)
    func completeFlow(on scene: Scene, style: CompleteFlowNavigationStyle)
    func goBackInFlow(to destination: Scene?, from source: Scene)
}

// MARK: - Implementation

struct ViewControllerNavigator: Navigator {
    
    typealias Scene = UIViewController
    
    private let animatedTransitions: Bool
    
    init(animatedTransitions: Bool = UIView.areAnimationsEnabled) {
        self.animatedTransitions = animatedTransitions
    }
    
    func newFlow(from source: Scene, to destination: Scene, style: NewFlowNavigationStyle) {
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
            
        case .tabBar(let item) where source is UITabBarController:
            let navigationController = BaseNavigationController(rootViewController: destination)

            let image: UIImage? = .init(systemName: item.imageName) ?? .init(named: item.imageName)
            navigationController.tabBarItem = UITabBarItem(title: item.title, image: image, selectedImage: nil)

            source.addChild(navigationController)
            
        default:
            fatalError("Unsupported combination of source: \(source), destination: \(destination), style: \(style)")
        }
    }
    
    func continueFlow(from source: Scene, to destination: Scene) {
        source.navigationController?.pushViewController(destination, animated: animatedTransitions)
    }

    func completeFlow(on scene: Scene, style: CompleteFlowNavigationStyle) {
        switch style {
        case .dismissModal:
            scene.dismiss(animated: animatedTransitions)
        case .unembed:
            scene.unembed()
        }
    }
    
    func goBackInFlow(to destination: Scene?, from source: Scene) {
        if let destination = destination {
            source.navigationController?.popToViewController(destination, animated: animatedTransitions)
        } else {
            source.navigationController?.popViewController(animated: animatedTransitions)
        }
    }
    
}
