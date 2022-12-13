//
//  DynamicItemsFetcher.swift
//  CoordinatorApp
//
//  Created by Dre on 09/08/2021.
//

import Combine
import Foundation

public struct FetchedDynamicItem {
    public let index: Int
    public let name: String
}

public protocol HasDynamicItemsFetchable: AnyObject {
    var dynamicItemsFetcher: DynamicItemsFetchable { get }
}

public protocol DynamicItemsFetchable: AnyObject {
    var fetchItems: AnyPublisher<[FetchedDynamicItem], Error> { get }
}

final class DynamicItemsFetcher: DynamicItemsFetchable {

    var fetchItems: AnyPublisher<[FetchedDynamicItem], Error> {
        Future<[FetchedDynamicItem], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let items: [FetchedDynamicItem] = [
                    .init(index: 0, name: "First Item"),
                    .init(index: 1, name: "Second Item"),
                    .init(index: 2, name: "Third Item"),
                    .init(index: 3, name: "Fourth Item"),
                    .init(index: 4, name: "Fifth Item"),
                    .init(index: 5, name: "Sixth Item"),
                    .init(index: 6, name: "Seventh Item"),
                    .init(index: 7, name: "Eighth Item"),
                    .init(index: 8, name: "Ninth Item"),
                    .init(index: 9, name: "Tenth Item"),
                ]
                promise(.success(items))
            }
        }.eraseToAnyPublisher()
    }

}
