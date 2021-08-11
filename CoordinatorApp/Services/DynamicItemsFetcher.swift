//
//  DynamicItemsFetcher.swift
//  CoordinatorApp
//
//  Created by Dre on 09/08/2021.
//

import Combine
import Foundation

public struct DynamicInfoItem: Identifiable {
    public let id: Int
    public let title: String
}

public protocol DynamicItemsFetchable: AnyObject {
    var fetchItems: AnyPublisher<[DynamicInfoItem], Error> { get }
}

final class DynamicItemsFetcher: DynamicItemsFetchable {

    var fetchItems: AnyPublisher<[DynamicInfoItem], Error> {
        Future<[DynamicInfoItem], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let items: [DynamicInfoItem] = [
                    .init(id: 0, title: "First Item"),
                    .init(id: 1, title: "Second Item"),
                    .init(id: 2, title: "Third Item"),
                    .init(id: 3, title: "Fourth Item"),
                    .init(id: 4, title: "Fifth Item"),
                    .init(id: 5, title: "Sixth Item"),
                    .init(id: 6, title: "Seventh Item"),
                    .init(id: 7, title: "Eighth Item"),
                    .init(id: 8, title: "Ninth Item"),
                    .init(id: 9, title: "Tenth Item"),
                ]
                promise(.success(items))
            }
        }.eraseToAnyPublisher()
    }

}
