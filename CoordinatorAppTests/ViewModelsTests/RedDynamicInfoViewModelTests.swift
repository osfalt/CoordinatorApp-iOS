//
//  RedDynamicInfoViewModelTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 26/09/2021.
//

import Combine
import UIKit
import XCTest
@testable import CoordinatorApp

class RedDynamicInfoViewModelTests: XCTestCase {

    private var fetcher: MockDynamicItemsFetcher!
    private var sut: RedDynamicInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        fetcher = MockDynamicItemsFetcher()
        sut = RedDynamicInfoViewModel(fetcher: fetcher)
    }

    // MARK: - Tests
    
    func testViewDidLoad_TriggersFetchInProgress() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertNotNil(fetcher.fetchItemsPromise)
        XCTAssertTrue(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testViewDidLoad_TriggersSuccessfulFetch() {
        // given
        let fetchedItems: [FetchedDynamicItem] = [
            .init(index: 0, name: "First Mock Item"),
            .init(index: 1, name: "Second Mock Item"),
            .init(index: 2, name: "Third Mock Item")
        ]
        
        // when
        sut.viewDidLoad()
        fetcher.fetchItemsPromise?(.success(fetchedItems))
        
        // then
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.items.count, fetchedItems.count)
        XCTAssertEqual(sut.items.map(\.title), fetchedItems.map(\.name))
        XCTAssertEqual(sut.items.map(\.id), fetchedItems.map(\.index))
    }
    
    func testViewDidLoad_TriggersFailedFetch() {
        // when
        sut.viewDidLoad()
        fetcher.fetchItemsPromise?(.failure(MockError.test))
        
        // then
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testDidTapReloadButton_TriggersFetchInProgress() {
        // when
        sut.didTapReloadButton()
        
        // then
        XCTAssertNotNil(fetcher.fetchItemsPromise)
        XCTAssertTrue(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testDidTapReloadButton_TriggersSuccessfulFetch() {
        // given
        let fetchedItems: [FetchedDynamicItem] = [
            .init(index: 0, name: "First Mock Item"),
            .init(index: 1, name: "Second Mock Item"),
            .init(index: 2, name: "Third Mock Item")
        ]
        
        // when
        sut.didTapReloadButton()
        fetcher.fetchItemsPromise?(.success(fetchedItems))
        
        // then
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.items.count, fetchedItems.count)
        XCTAssertEqual(sut.items.map(\.title), fetchedItems.map(\.name))
        XCTAssertEqual(sut.items.map(\.id), fetchedItems.map(\.index))
    }
    
    func testDidSelectItem() throws {
        // given
        let fetchedItems: [FetchedDynamicItem] = [
            .init(index: 0, name: "First Mock Item"),
            .init(index: 1, name: "Second Mock Item"),
            .init(index: 2, name: "Third Mock Item")
        ]
        
        var selectedItem: Item?
        sut.didSelectItemPublisher
            .sink { selectedItem = $0 }
            .store(in: &cancellables)
        
        // when
        sut.didTapReloadButton()
        fetcher.fetchItemsPromise?(.success(fetchedItems))
        
        let expectedItem = sut.items[1]
        sut.didSelectCell(expectedItem)
        
        // then
        XCTAssertNotNil(selectedItem)
        XCTAssertEqual(selectedItem?.id, expectedItem.id)
        XCTAssertEqual(selectedItem?.title, expectedItem.title)
    }

}

// MARK: - Mocks

enum MockError: Error {
    case test
}

private class MockDynamicItemsFetcher: DynamicItemsFetchable {
    
    var fetchItemsPromise: ((Result<[FetchedDynamicItem], Error>) -> Void)?
    
    var fetchItems: AnyPublisher<[FetchedDynamicItem], Error> {
        Future<[FetchedDynamicItem], Error> { promise in
            self.fetchItemsPromise = promise
        }.eraseToAnyPublisher()
    }
    
}
