//
//  Coordinating.swift
//  CoordinatorApp
//
//  Created by Dre on 13/08/2021.
//

import Foundation

public protocol Coordinating: DeepLinkHandling {

    var onFinish: (() -> Void)? { get set }

    func start()

}
