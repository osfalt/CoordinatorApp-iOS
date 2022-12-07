//
//  BaseViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import SwiftUI
import UIKit

public protocol SwiftUIContentRendering: UIViewController {

    associatedtype Content: View
    var content: Content { get }

}

open class BaseViewController<Content: View>: UIViewController, SwiftUIContentRendering {

    open var content: Content {
        fatalError("Should be implemented in children view controllers")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        embed(content)
    }

}
