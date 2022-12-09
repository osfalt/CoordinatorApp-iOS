//
//  BaseViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import SwiftUI
import UIKit
import Combine

public protocol SwiftUIContentRendering: UIViewController {

    associatedtype Content: View
    var content: Content { get }

}

open class BaseViewController<Content: View>: UIViewController, SwiftUIContentRendering {

    open var content: Content {
        fatalError("Should be implemented in children view controllers")
    }
    
    private var cancellables: Set<AnyCancellable> = []

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        embed(content)
        observeDidPopViewController()
    }
    
    func didTapBackButton() {
        // override in children
    }
    
    private func observeDidPopViewController() {
        guard let baseNavigationController = navigationController as? BaseNavigationController else {
            return
        }
        
        baseNavigationController.didPopViewControllerPublisher
            .filter { [weak self] in $0.popped == self }
            .sink { [weak self] _, _ in
                self?.didTapBackButton()
            }
            .store(in: &cancellables)
    }

}
