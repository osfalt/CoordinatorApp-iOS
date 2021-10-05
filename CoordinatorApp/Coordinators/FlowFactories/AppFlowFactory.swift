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

    init(
        authorizationFlow: AuthorizationFlowFactoryProtocol = AuthorizationFlowFactory(),
        mainFlow: MainFlowFactoryProtocol = MainFlowFactory()
    ) {
        self.authorizationFlow = authorizationFlow
        self.mainFlow = mainFlow
    }

    func makeFlow() -> AppFlow {
        let rootVC = RootViewController()
        let coordinator = AppCoordinator(
            rootViewController: rootVC,
            flowFactory: self,
            authorizationTokenStore: AuthorizationTokenStore(store: UserDefaults.standard)
        )
        #warning("Create init for `AppFlowFactory` and inject AuthorizationTokenStore(store: UserDefaults.standard)")
        return (rootVC, coordinator)
    }

}
