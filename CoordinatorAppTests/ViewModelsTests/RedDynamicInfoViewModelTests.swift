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

    private var fetcherMock: DynamicItemsFetcherMock!
    private var outputDelegateSpy: RedDynamicInfoSceneOutputDelegateSpy!
    private var sut: RedDynamicInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        fetcherMock = DynamicItemsFetcherMock()
        outputDelegateSpy = RedDynamicInfoSceneOutputDelegateSpy()
        sut = RedDynamicInfoViewModel(fetcher: fetcherMock, outputDelegate: outputDelegateSpy)
    }

    // MARK: - Tests
    
    func testViewDidLoad_TriggersFetchInProgress() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertNotNil(fetcherMock.fetchItemsPromise)
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
        fetcherMock.fetchItemsPromise?(.success(fetchedItems))
        
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
        fetcherMock.fetchItemsPromise?(.failure(DummyError.error))
        
        // then
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testDidTapReloadButton_TriggersFetchInProgress() {
        // when
        sut.didTapReloadButton()
        
        // then
        XCTAssertNotNil(fetcherMock.fetchItemsPromise)
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
        fetcherMock.fetchItemsPromise?(.success(fetchedItems))
        
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
        
        // when
        sut.didTapReloadButton()
        fetcherMock.fetchItemsPromise?(.success(fetchedItems))
        
        let selectedItem = sut.items[1]
        sut.didSelectCell(selectedItem)
        
        // then
        let expectedItem = RedDynamicInfoItem(id: 1, title: "Second Mock Item")
        XCTAssertEqual(outputDelegateSpy.log, [.redDynamicInfoSceneDidSelectItem(expectedItem)])
    }

}

// MARK: - Mocks

private enum DummyError: Error {
    case error
}

private class RedDynamicInfoSceneOutputDelegateSpy: RedDynamicInfoSceneOutputDelegate {
    
    enum MethodCall: Equatable {
        case redDynamicInfoSceneDidSelectItem(RedDynamicInfoItem)
        case redDynamicInfoSceneDidTapBackButton
    }
    
    private(set) var log: [MethodCall] = []
    
    func redDynamicInfoSceneDidSelectItem(_ item: RedDynamicInfoItem) {
        log.append(.redDynamicInfoSceneDidSelectItem(item))
    }
    
    func redDynamicInfoSceneDidTapBackButton() {
        log.append(.redDynamicInfoSceneDidTapBackButton)
    }
    
}
