//
//  AuthorizationServiceMock.swift
//  CoordinatorAppTests
//
//  Created by Dre on 13/12/2022.
//

import Foundation
import CoordinatorApp

class AuthorizationServiceMock: AuthorizationServicing {
    
    var registerUser_completion: ((Result<Void, Error>) -> Void)?
    var logInUser_completion: ((Result<Void, Error>) -> Void)?
    var logOut_completion: ((Result<Void, Error>) -> Void)?
    
    func registerUser(completion: @escaping (Result<Void, Error>) -> Void) {
        registerUser_completion = completion
    }
    
    func logInUser(completion: @escaping (Result<Void, Error>) -> Void) {
        logInUser_completion = completion
    }
    
    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        logOut_completion = completion
    }
    
}
