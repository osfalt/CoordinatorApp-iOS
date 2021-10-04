//
//  KeyValueStoring.swift
//  CoordinatorApp
//
//  Created by Dre on 02/10/2021.
//

import Combine
import Foundation

public protocol KeyValueStoring {

    func getValue<Value>(forKey key: String) -> Value?
    func save<Value>(value: Value, forKey key: String)
    func removeValue(forKey key: String)

    func valueDidChangePublisher<Value: Equatable>(for key: String) -> AnyPublisher<Value?, Never>

}

extension UserDefaults: KeyValueStoring {

    public func getValue<Value>(forKey key: String) -> Value? {
        return object(forKey: key) as? Value
    }

    public func save<Value>(value: Value, forKey key: String) {
        set(value, forKey: key)
    }

    public func removeValue(forKey key: String) {
        removeObject(forKey: key)
    }

    public func valueDidChangePublisher<Value: Equatable>(for key: String) -> AnyPublisher<Value?, Never> {
        return NotificationCenter.default
           .publisher(for: UserDefaults.didChangeNotification, object: nil)
           .map { [weak self] _ in self?.getValue(forKey: key) }
           .removeDuplicates()
           .eraseToAnyPublisher()
    }

}
