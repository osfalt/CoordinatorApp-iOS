//
//  DynamicItemsFetcherMock.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import Combine
import CoordinatorApp

class DynamicItemsFetcherMock: DynamicItemsFetchable {
    
    var fetchItemsPromise: ((Result<[FetchedDynamicItem], Error>) -> Void)?
    
    var fetchItems: AnyPublisher<[FetchedDynamicItem], Error> {
        Future<[FetchedDynamicItem], Error> { promise in
            self.fetchItemsPromise = promise
        }.eraseToAnyPublisher()
    }
    
}
