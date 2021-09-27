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

    enum Spec {
        static let timeout = MockDynamicItemsFetcher.Spec.fetchDuration * 2 // multiplie by 2 just in case
    }

    private var fetcher: MockDynamicItemsFetcher!
    private var viewModel: RedDynamicInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        fetcher = MockDynamicItemsFetcher()
        viewModel = RedDynamicInfoViewModel(fetcher: fetcher)
    }

    // MARK: - Tests
    
    func testSuccessfulFetchTriggeredByViewDidLoad() throws {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.items.isEmpty)

        let expectation = XCTestExpectation(description: "isLoading - viewDidLoad")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.items.isEmpty)

        wait(for: [expectation], timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.items.count, fetcher.fetchedItems.count)
        XCTAssertEqual(viewModel.items.map(\.title), fetcher.fetchedItems.map(\.name))
        XCTAssertEqual(viewModel.items.map(\.id), fetcher.fetchedItems.map(\.index))
    }
    
    func testSuccessfulFetchTriggeredByDidTapReloadButton() throws {
        fetcher.asyncFetch = false
        viewModel.viewDidLoad()

        fetcher.asyncFetch = true

        let expectation = XCTestExpectation(description: "isLoading - didTapReloadButton")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.didTapReloadButton()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.items.isEmpty)

        wait(for: [expectation], timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.items.count, fetcher.fetchedItems.count)
        XCTAssertEqual(viewModel.items.map(\.title), fetcher.fetchedItems.map(\.name))
        XCTAssertEqual(viewModel.items.map(\.id), fetcher.fetchedItems.map(\.index))
    }

    func testFailedFetchTriggeredByViewDidLoad() throws {
        fetcher.successfulFetch = false
        fetcher.asyncFetch = false
        viewModel.viewDidLoad()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertTrue(viewModel.items.isEmpty)
    }

    func testDidSelectItem() throws {
        fetcher.asyncFetch = false
        viewModel.viewDidLoad()

        guard let item = viewModel.items.first else {
            XCTFail()
            return
        }

        let didSelectItemExpectation = XCTestExpectation(description: "didSelectItem")

        viewModel.didSelectItemPublisher
            .sink { selectedItem in
                XCTAssertEqual(selectedItem.id, item.id)
                didSelectItemExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.didSelectCell(item)
        wait(for: [didSelectItemExpectation], timeout: 0.01)
    }

}

// MARK: - Mocks

private class MockDynamicItemsFetcher: DynamicItemsFetchable {

    enum Spec {
        static let fetchDuration: TimeInterval = 0.05
    }

    var successfulFetch: Bool = true
    var asyncFetch: Bool = true

    let fetchedItems: [FetchedDynamicItem] = [
        .init(index: 0, name: "First Mock Item"),
        .init(index: 1, name: "Second Mock Item"),
        .init(index: 2, name: "Third Mock Item"),
    ]

    var fetchItems: AnyPublisher<[FetchedDynamicItem], Error> {
        Future<[FetchedDynamicItem], Error> { promise in
            let fetch = {
                if self.successfulFetch {
                    promise(.success(self.fetchedItems))
                } else {
                    promise(.failure(NSError()))
                }
            }

            if self.asyncFetch {
                DispatchQueue.main.asyncAfter(deadline: .now() + Spec.fetchDuration, execute: fetch)
            } else {
                fetch()
            }
        }.eraseToAnyPublisher()
    }

}
