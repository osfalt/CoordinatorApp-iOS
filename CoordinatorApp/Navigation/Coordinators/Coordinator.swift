//
//  Coordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

protocol Coordinator: AnyObject {
    
    associatedtype Scene
    
    var scenes: [Scene] { get }
    var children: [any Coordinator] { get }
    
    @discardableResult
    func start() -> Scene
    
}

extension Coordinator {
    var currentScene: Scene? { scenes.last }
}
