//
//  UIViewController+Child.swift
//  CoordinatorApp
//
//  Created by Dre on 30/07/2021.
//

import SwiftUI
import UIKit

extension UIViewController {

    public func embed(_ child: UIViewController) {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    public func unembed() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    public func embed<Content: View>(_ content: Content) {
        let hostingVC = UIHostingController(rootView: content)
        embed(hostingVC)
    }

}
