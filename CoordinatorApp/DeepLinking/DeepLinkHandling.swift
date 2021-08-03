//
//  DeepLinkHandling.swift
//  CoordinatorApp
//
//  Created by Dre on 08/08/2021.
//

import Foundation

public protocol DeepLinkHandling: AnyObject {

    @discardableResult
    func handleDeepLink(_ deepLink: DeepLink) -> Bool
    
}
