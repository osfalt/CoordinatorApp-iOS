//
//  MockMainFlowFactory.swift
//  CoordinatorAppTests
//
//  Created by Dre on 12/08/2021.
//

import UIKit
import CoordinatorApp

final class MockMainFlowFactory: MainFlowFactoryProtocol {
    let redFlow: RedFlowFactoryProtocol
    let greenFlow: GreenFlowModuleFactoryProtocol

    private(set) lazy var tabBarController = MockTabBarController()

    init(
        redFlow: RedFlowFactoryProtocol,
        greenFlow: GreenFlowModuleFactoryProtocol
    ) {
        self.redFlow = redFlow
        self.greenFlow = greenFlow
    }

    func makeFlow() -> MainFlow {
        let coordinator = MainCoordinator(flowViewController: tabBarController, flowFactory: self)
        return (tabBarController, coordinator)
    }
}

final class MockTabBarController: UITabBarController {
    func selectRedFlowTab() {
        selectedIndex = MainCoordinator.TabIndex.redFlow
        if let selectedViewController = selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }

    func selectGreenFlowTab() {
        selectedIndex = MainCoordinator.TabIndex.greenFlow
        if let selectedViewController = selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }
}
