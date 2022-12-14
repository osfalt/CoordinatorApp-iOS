//
//  AuthorizationService.swift
//  CoordinatorApp
//
//  Created by Dre on 11/12/2022.
//

import Combine
import Foundation

public protocol HasAuthorizationServicing {
    var authorizationService: AuthorizationServicing { get }
}

public protocol AuthorizationServicing: AnyObject {
    func registerUser(completion: @escaping (Result<Void, Error>) -> Void)
    func logInUser(completion: @escaping (Result<Void, Error>) -> Void)
    func logOut(completion: @escaping (Result<Void, Error>) -> Void)
}

public final class AuthorizationService: AuthorizationServicing {
    
    private let store: AuthorizationTokenStoring
    
    public init(store: AuthorizationTokenStoring) {
        self.store = store
    }
    
    public func registerUser(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.store.token = UUID().uuidString
            completion(.success(()))
        }
    }
    
    public func logInUser(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.store.token = UUID().uuidString
            completion(.success(()))
        }
    }
    
    public func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        store.token = nil
        completion(.success(()))
    }
    
}
