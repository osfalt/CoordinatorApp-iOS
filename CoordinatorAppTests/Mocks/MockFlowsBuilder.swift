//
//  MockFlowsBuilder.swift
//  CoordinatorAppTests
//
//  Created by Dre on 12/08/2021.
//

import UIKit
import CoordinatorApp

final class MockFlowsBuilder: FlowsBuilderProtocol {
    let redFlow: RedFlowBuilderProtocol
    let greenFlow: GreenFlowBuilderProtocol

    private(set) lazy var tabBarController = MockTabBarController()

    init(
        redFlow: RedFlowBuilderProtocol,
        greenFlow: GreenFlowBuilderProtocol
    ) {
        self.redFlow = redFlow
        self.greenFlow = greenFlow
    }

    func makeFlowViewController() -> UITabBarController {
        return tabBarController
    }
}

final class MockTabBarController: UITabBarController {
    func selectRedFlowTab() {
        selectedIndex = AppCoordinator.TabIndex.redFlow
        if let selectedViewController = selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }

    func selectGreenFlowTab() {
        selectedIndex = AppCoordinator.TabIndex.greenFlow
        if let selectedViewController = selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }
}
