//
//  AuthorizationTokenStore.swift
//  CoordinatorApp
//
//  Created by Dre on 02/10/2021.
//

import Combine
import Foundation

public protocol HasAuthorizationTokenStoring {
    var authorizationTokenStore: AuthorizationTokenStoring { get }
}

public protocol AuthorizationTokenStoring: AnyObject {
    var token: String? { get set }
    var tokenPublisher: Published<String?>.Publisher { get }
}

public final class AuthorizationTokenStore: ObservableObject, AuthorizationTokenStoring {

    enum Key {
        static let token = "authorization_token"
    }

    @Published public var token: String? {
        didSet {
            guard token != oldValue else { return }
            if let token {
                store.save(value: token, forKey: Key.token)
            } else {
                store.removeValue(forKey: Key.token)
            }
        }
    }
    
    public var tokenPublisher: Published<String?>.Publisher { $token }

    private let store: KeyValueStoring
    private var cancellables: Set<AnyCancellable> = []

    public init(store: KeyValueStoring) {
        self.store = store
        self.token = store.getValue(forKey: Key.token)
        
        self.store.valueDidChangePublisher(for: Key.token)
            .sink { [weak self] authToken in
                self?.token = authToken
            }
            .store(in: &cancellables)
    }

}
