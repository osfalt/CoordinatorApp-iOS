//
//  AuthorizationTokenStore.swift
//  CoordinatorApp
//
//  Created by Dre on 02/10/2021.
//

import Combine
import Foundation

public final class AuthorizationTokenStore: ObservableObject {

    enum Key {
        static let token = "authorization_token"
    }

    @Published public var token: String? {
        didSet {
            guard token != oldValue else { return }
            store.save(value: token, forKey: Key.token)
        }
    }

    private let store: KeyValueStoring
    private var cancellables: Set<AnyCancellable> = []

    public init(store: KeyValueStoring) {
        self.store = store
        self.token = store.getValue(forKey: Key.token)
        
        self.store.valueDidChangePublisher(for: Key.token)
            .sink { [weak self] (authToken: String?) in
                self?.token = authToken
            }
            .store(in: &cancellables)
    }

}
