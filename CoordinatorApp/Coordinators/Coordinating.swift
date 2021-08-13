//
//  Coordinating.swift
//  CoordinatorApp
//
//  Created by Dre on 13/08/2021.
//

import Foundation

public protocol Coordinating: AnyObject {

    var onFinish: (() -> Void)? { get set }
    var animationEnabled: Bool { get }

    func start()

}
