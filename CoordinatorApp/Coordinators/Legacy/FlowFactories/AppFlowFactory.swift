//
//  AppFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 01/10/2021.
//

import UIKit

public protocol AppFlowFactoryProtocol {

    typealias AppFlow = (flowController: UIViewController, coordinator: Coordinating)

    var authorizationFlow: AuthorizationFlowFactoryProtocol { get }
    var mainFlow: MainFlowFactoryProtocol { get }

    func makeFlow() -> AppFlow

}

final class AppFlowFactory: AppFlowFactoryProtocol {

    let authorizationFlow: AuthorizationFlowFactoryProtocol
    let mainFlow: MainFlowFactoryProtocol
    private let dependencies: Dependencies

    init(
        authorizationFlow: AuthorizationFlowFactoryProtocol,
        mainFlow: MainFlowFactoryProtocol,
        dependencies: Dependencies
    ) {
        self.authorizationFlow = authorizationFlow
        self.mainFlow = mainFlow
        self.dependencies = dependencies
    }

    func makeFlow() -> AppFlow {
        let rootVC = RootViewController()
        let coordinator = AppCoordinator(
            rootViewController: rootVC,
            flowFactory: self,
            authorizationTokenStore: dependencies.authorizationTokenStore
        )
        return (rootVC, coordinator)
    }

}
