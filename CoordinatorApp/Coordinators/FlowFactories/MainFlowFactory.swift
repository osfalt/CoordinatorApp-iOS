//
//  MainFlowFactory.swift
//  CoordinatorApp
//
//  Created by Dre on 25/09/2021.
//

import UIKit

public protocol MainFlowFactoryProtocol {

    typealias MainFlow = (flowController: UITabBarController, coordinator: Coordinating)

    var redFlow: RedFlowFactoryProtocol { get }
    var greenFlow: GreenFlowFactoryProtocol { get }

    func makeFlow() -> MainFlow

}

final class MainFlowFactory: MainFlowFactoryProtocol {

    let redFlow: RedFlowFactoryProtocol
    let greenFlow: GreenFlowFactoryProtocol

    init(
        redFlow: RedFlowFactoryProtocol = RedFlowFactory(),
        greenFlow: GreenFlowFactoryProtocol = GreenFlowFactory()
    ) {
        self.redFlow = redFlow
        self.greenFlow = greenFlow
    }

    func makeFlow() -> MainFlow {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .lightGray
        let coordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: self)
        return (tabBarController, coordinator)
    }

}
