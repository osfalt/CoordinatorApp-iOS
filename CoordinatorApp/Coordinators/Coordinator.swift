//
//  Coordinator.swift
//  CoordinatorApp
//
//  Created by Dre on 30/06/2024.
//

import Foundation

protocol Coordinator: AnyObject {
    
    associatedtype Scene
    
    @discardableResult
    func start() -> Scene
    
}
