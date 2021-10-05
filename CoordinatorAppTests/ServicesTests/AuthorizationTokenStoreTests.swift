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

    private var authorizationTokenStore: AuthorizationTokenStore!
    private var keyValueStore: KeyValueStoring!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        keyValueStore = MockAuthorizationTokenKeyValueStore()
        authorizationTokenStore = AuthorizationTokenStore(store: keyValueStore)
    }

    // MARK: - Tests

    func testSaveToken() throws {
        let initialValue: String? = keyValueStore.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNil(initialValue)

        authorizationTokenStore.token = "TEST_TOKEN"
        let savedValue: String? = keyValueStore.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertEqual(savedValue, "TEST_TOKEN")
    }

    func testRemoveToken() throws {
        authorizationTokenStore.token = "TEST_TOKEN"
        let initialValue: String? = keyValueStore.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNotNil(initialValue)

        authorizationTokenStore.token = nil
        let savedValue: String? = keyValueStore.getValue(forKey: AuthorizationTokenStore.Key.token)
        XCTAssertNil(savedValue)
    }

    func testTokenDidChange() throws {
        let expectation = XCTestExpectation(description: "TokenDidChange")

        authorizationTokenStore.$token
            .dropFirst()
            .sink { token in
                XCTAssertEqual(token, "TEST_TOKEN")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        authorizationTokenStore.token = "TEST_TOKEN"
        wait(for: [expectation], timeout: 0.01)
    }

}

// MARK: - Mock

private class MockAuthorizationTokenKeyValueStore: KeyValueStoring {

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
