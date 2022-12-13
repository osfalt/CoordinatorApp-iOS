//
//  AuthorizationTokenStoreMock.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import Combine
import CoordinatorApp

class AuthorizationTokenStoreMock: AuthorizationTokenStoring {
    
    @Published var token: String?
    
    var tokenPublisher: Published<String?>.Publisher {
        $token
    }
    
}
