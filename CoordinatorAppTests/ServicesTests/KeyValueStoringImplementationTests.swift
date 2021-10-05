//
//  KeyValueStoringImplementationTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 05/10/2021.
//

import Combine
import XCTest
@testable import CoordinatorApp

class KeyValueStoringImplementationTests: XCTestCase {

    private var keyValueStore: KeyValueStoring!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        keyValueStore = UserDefaults.standard
    }

    // MARK: - Tests

    func testSaveAndGetValueWithCorrectType() throws {
        keyValueStore.save(value: 777, forKey: "TEST_KEY")
        let value: Int? = keyValueStore.getValue(forKey: "TEST_KEY")
        XCTAssertEqual(value, 777)
    }

    func testSaveAndGetValueWithWrongType() throws {
        keyValueStore.save(value: 777, forKey: "TEST_KEY")
        let value: String? = keyValueStore.getValue(forKey: "TEST_KEY")
        XCTAssertNil(value)
    }

    func testRemoveValue() throws {
        keyValueStore.save(value: 777, forKey: "TEST_KEY")
        let savedValue: Int? = keyValueStore.getValue(forKey: "TEST_KEY")
        XCTAssertEqual(savedValue, 777)

        keyValueStore.removeValue(forKey: "TEST_KEY")
        let removedValue: String? = keyValueStore.getValue(forKey: "TEST_KEY")
        XCTAssertNil(removedValue)
    }

    func testValueDidChange() throws {
        let expectation = XCTestExpectation(description: "ValueDidChange")

        keyValueStore.valueDidChangePublisher(for: "TEST_KEY")
            .sink { (value: Int?) in
                XCTAssertEqual(value, 777)
                expectation.fulfill()
            }
            .store(in: &cancellables)


        keyValueStore.save(value: 777, forKey: "TEST_KEY")
        wait(for: [expectation], timeout: 0.01)
    }

}
