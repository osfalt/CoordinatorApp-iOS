//
//  AuthorizationTokenStoreTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 04/10/2021.
//

import Combine
import XCTest
@testable import CoordinatorApp

class AuthorizationTokenStoreTests: XCTestCase {

    private var sut: AuthorizationTokenStore!
    private var keyValueStoreMock: KeyValueStoring!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        keyValueStoreMock = KeyValueStoreMock()
        sut = AuthorizationTokenStore(store: keyValueStoreMock)
    }

    // MARK: - Tests

    func testSaveToken() throws {
        let initialValue: String? = keyValueStoreMock.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNil(initialValue)

        sut.token = "TEST_TOKEN"
        let savedValue: String? = keyValueStoreMock.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertEqual(savedValue, "TEST_TOKEN")
    }

    func testRemoveToken() throws {
        sut.token = "TEST_TOKEN"
        let initialValue: String? = keyValueStoreMock.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNotNil(initialValue)

        sut.token = nil
        let savedValue: String? = keyValueStoreMock.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNil(savedValue)
    }

    func testTokenDidChange() throws {
        var token: String?
        sut.$token
            .sink { token = $0 }
            .store(in: &cancellables)

        sut.token = "TEST_TOKEN"
        
        XCTAssertEqual(token, "TEST_TOKEN")
    }

}

// MARK: - Mock

private class KeyValueStoreMock: KeyValueStoring {

    private static let tokenKey = AuthorizationTokenStore.Key.token

    private var dictionary: [String: Any] = [:] {
        didSet {
            guard let value = dictionary[Self.tokenKey] else { return }
            subject.send(value)
        }
    }

    private let subject = PassthroughSubject<Any, Never>()

    public func getValue<Value>(forKey key: String) -> Value? {
        return dictionary[key] as? Value
    }

    public func save<Value>(value: Value, forKey key: String) {
        dictionary[key] = value
    }

    public func removeValue(forKey key: String) {
        dictionary.removeValue(forKey: key)
    }

    public func valueDidChangePublisher<Value: Equatable>(for key: String) -> AnyPublisher<Value?, Never> {
        subject.map { $0 as? Value }.eraseToAnyPublisher()
    }

}
