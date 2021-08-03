//
//  BaseNavigationControllerTests.swift
//  BrandNewAppTests
//
//  Created by Dre on 02/08/2021.
//

import UIKit
import XCTest
@testable import BrandNewApp

class BaseNavigationControllerTests: XCTestCase {

    private var navigationController: BaseNavigationController!
    private var delegate: NavigationControllerDelegate!

    func testSetupNavigationControllerDelegate() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController

        delegate = NavigationControllerDelegate()
        navigationController.delegate = delegate
        XCTAssert(navigationController.delegate === delegate)

        XCTAssertNil(delegate.willShownViewController)
        XCTAssertNil(delegate.didShownViewController)

        let pushedViewController = UIViewController()
        navigationController.pushViewController(pushedViewController, animated: true)

        RunLoop.current.run(until: Date())

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers.contains(rootViewController))
        XCTAssertTrue(navigationController.viewControllers.contains(pushedViewController))
        XCTAssertTrue(navigationController.topViewController === pushedViewController)

        XCTAssertNotNil(delegate.willShownViewController)
        XCTAssertNotNil(delegate.didShownViewController)
        XCTAssertTrue(delegate.willShownViewController === pushedViewController)
        XCTAssertTrue(delegate.didShownViewController === pushedViewController)
    }

    func testDidPopViewController() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController

        delegate = NavigationControllerDelegate()
        navigationController.delegate = delegate

        let pushedViewController = UIViewController()
        navigationController.pushViewController(pushedViewController, animated: true)

        RunLoop.current.run(until: Date())

        let expectation = expectation(description: "didPopViewController")
        navigationController.didPopViewController = { viewController in
            XCTAssertTrue(viewController === pushedViewController, "\(viewController) is not equal \(pushedViewController)")
            expectation.fulfill()
        }
        navigationController.popViewController(animated: true)
        waitForExpectations(timeout: 1)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.topViewController === rootViewController)
    }

}

// MARK: - NavigationControllerDelegate

private class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    var willShownViewController: UIViewController?
    var didShownViewController: UIViewController?

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        willShownViewController = viewController
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        didShownViewController = viewController
    }

}
