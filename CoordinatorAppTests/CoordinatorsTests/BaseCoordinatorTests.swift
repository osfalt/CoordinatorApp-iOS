//
//  BaseCoordinatorTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 01/07/2024.
//

import XCTest
@testable import CoordinatorApp

class BaseCoordinatorTests: XCTestCase {
    
    var navigatorSpy: NavigatorSpy!
    var factoryMock: SceneFactoryMock!
    var dependenciesMock: DependenciesMock!
    var authorizationTokenStoreMock: AuthorizationTokenStoreMock!
    
    override func setUp() {
        super.setUp()
        
        navigatorSpy = NavigatorSpy()
        factoryMock = SceneFactoryMock()
        
        authorizationTokenStoreMock = AuthorizationTokenStoreMock()
        dependenciesMock = DependenciesMock(authorizationTokenStore: authorizationTokenStoreMock)
    }
    
    func givenUserIsGuest() {
        authorizationTokenStoreMock.token = nil
    }
    
    func givenUserIsLoggedIn() {
        authorizationTokenStoreMock.token = "auth_token"
    }
    
}
