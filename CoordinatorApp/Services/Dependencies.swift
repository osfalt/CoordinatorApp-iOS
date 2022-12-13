//
//  Dependencies.swift
//  CoordinatorApp
//
//  Created by Dre on 26/10/2021.
//

import Foundation

public protocol Dependencies: HasDynamicItemsFetchable, HasAuthorizationTokenStoring, HasAuthorizationServicing {

    var dynamicItemsFetcher: DynamicItemsFetchable { get }
    var authorizationTokenStore: AuthorizationTokenStoring { get }
    var authorizationService: AuthorizationServicing { get }

}

final class AppDependencies: Dependencies {

    // MARK: - Dependencies
    private(set) lazy var dynamicItemsFetcher: DynamicItemsFetchable = DynamicItemsFetcher()
    private(set) lazy var authorizationTokenStore: AuthorizationTokenStoring = AuthorizationTokenStore(store: keyValueStore)
    private(set) lazy var authorizationService: AuthorizationServicing = AuthorizationService(store: authorizationTokenStore)

    // MARK: - Private
    private let keyValueStore: KeyValueStoring

    // MARK: - Init
    init(keyValueStore: KeyValueStoring = UserDefaults.standard) {
        self.keyValueStore = keyValueStore
    }

}
