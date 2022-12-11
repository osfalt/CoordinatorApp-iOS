//
//  AuthorizationService.swift
//  CoordinatorApp
//
//  Created by Dre on 11/12/2022.
//

import Combine
import Foundation

public protocol HasAuthorizationService {
    var authorizationService: AuthorizationServicing { get }
}

public protocol AuthorizationServicing: AnyObject {
    func registerUser()
    func logInUser()
}

public final class AuthorizationService: AuthorizationServicing {
    
    private let store: AuthorizationTokenStoring
    
    public init(store: AuthorizationTokenStoring) {
        self.store = store
    }
    
    public func registerUser() {
        store.token = UUID().uuidString
    }
    
    public func logInUser() {
        store.token = UUID().uuidString
    }
    
}
