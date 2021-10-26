//
//  Dependencies.swift
//  CoordinatorApp
//
//  Created by Dre on 26/10/2021.
//

import Foundation

public protocol Dependencies: AnyObject {

    var dynamicItemsFetcher: DynamicItemsFetchable { get }
    var authorizationTokenStore: AuthorizationTokenStore { get }

}

final class AppDependencies: Dependencies {

    // MARK: - Dependencies
    private(set) lazy var dynamicItemsFetcher: DynamicItemsFetchable = DynamicItemsFetcher()
    private(set) lazy var authorizationTokenStore = AuthorizationTokenStore(store: keyValueStore)

    // MARK: - Private
    private let keyValueStore: KeyValueStoring

    // MARK: - Init
    init(keyValueStore: KeyValueStoring = UserDefaults.standard) {
        self.keyValueStore = keyValueStore
    }

}
