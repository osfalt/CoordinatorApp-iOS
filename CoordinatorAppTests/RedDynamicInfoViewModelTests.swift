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
        static let timeout = MockDynamicItemsFetcher.Spec.fetchDuration * 2 // multiplication by 2 is fo sure
    }

    private var viewModel: RedDynamicInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        initialiseViewModel()
    }

    // MARK: - Tests
    
    func testSuccessfulFetchTriggeredByViewDidLoad() throws {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        let expectation = expectation(description: "isLoading")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        waitForExpectations(timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testSuccessfulFetchTriggeredByDidTapReloadButton() throws {
        // call viewDidLoad()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        let isLoadingForViewDidLoadExpectation = XCTestExpectation(description: "isLoading - viewDidLoad")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in isLoadingForViewDidLoadExpectation.fulfill() }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        wait(for: [isLoadingForViewDidLoadExpectation], timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        // call didTapReloadButton()
        let isLoadingForDidTapReloadButtonExpectation = XCTestExpectation(description: "isLoading - didTapReloadButton")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in isLoadingForDidTapReloadButtonExpectation.fulfill() }
            .store(in: &cancellables)

        viewModel.didTapReloadButton()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        wait(for: [isLoadingForDidTapReloadButtonExpectation], timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)
    }

    func testFailedFetchTriggeredByViewDidLoad() throws {
        initialiseViewModel(successfulFetch: false)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        let expectation = expectation(description: "isLoading")
        viewModel.$isLoading
            .filter { !$0 }
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertFalse(viewModel.showError)

        waitForExpectations(timeout: Spec.timeout)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertTrue(viewModel.showError)
    }

    // MARK: - Private methods

    private func initialiseViewModel(successfulFetch: Bool = true) {
        let fetcher = MockDynamicItemsFetcher(successfulFetch: successfulFetch)
        viewModel = RedDynamicInfoViewModel(fetcher: fetcher)
    }

}

// MARK: - Mocks

private class MockDynamicItemsFetcher: DynamicItemsFetchable {

    enum Spec {
        static let fetchDuration: TimeInterval = 0.05
    }

    private var successfulFetch: Bool

    init(successfulFetch: Bool = true) {
        self.successfulFetch = successfulFetch
    }

    var fetchItems: AnyPublisher<[DynamicInfoItem], Error> {
        Future<[DynamicInfoItem], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + Spec.fetchDuration) { [self] in
                if successfulFetch {
                    let items: [DynamicInfoItem] = [
                        .init(id: 0, title: "First Mock Item"),
                        .init(id: 1, title: "Second Mock Item"),
                        .init(id: 2, title: "Third Mock Item"),
                    ]
                    promise(.success(items))
                } else {
                    promise(.failure(NSError()))
                }
            }
        }.eraseToAnyPublisher()
    }

}
