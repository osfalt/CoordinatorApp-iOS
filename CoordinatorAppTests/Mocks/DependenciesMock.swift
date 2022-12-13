//
//  DependenciesMock.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import CoordinatorApp

struct DependenciesMock: Dependencies {
    
    var dynamicItemsFetcher: DynamicItemsFetchable
    var authorizationTokenStore: AuthorizationTokenStoring
    var authorizationService: AuthorizationServicing
    
    init(
        dynamicItemsFetcher: DynamicItemsFetchable = DynamicItemsFetcherMock(),
        authorizationTokenStore: AuthorizationTokenStoring = AuthorizationTokenStoreMock(),
        authorizationService: AuthorizationServicing = AuthorizationServiceMock()
    ) {
        self.dynamicItemsFetcher = dynamicItemsFetcher
        self.authorizationTokenStore = authorizationTokenStore
        self.authorizationService = authorizationService
    }
    
}
