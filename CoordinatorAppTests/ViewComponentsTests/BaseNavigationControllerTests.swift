//
//  BaseNavigationControllerTests.swift
//  CoordinatorAppTests
//
//  Created by Dre on 02/08/2021.
//

import Combine
import UIKit
import XCTest
@testable import CoordinatorApp

class BaseNavigationControllerTests: XCTestCase {

    private enum Spec {
        static let timeout: TimeInterval = 0.35
    }

    private var navigationController: BaseNavigationController!
    private var delegate: NavigationControllerDelegate!
    private var cancellables: Set<AnyCancellable> = []

    func testSetupNavigationControllerDelegate() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)

        // without this `NavigationControllerDelegate` callbacks don't work
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

    func testDidPopViewControllerWithTwoControllersInStack() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController

        let pushedViewController = UIViewController()
        navigationController.pushViewController(pushedViewController, animated: true)

        RunLoop.current.run(until: Date())

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.topViewController === pushedViewController)

        let expectation = expectation(description: "didPopViewController")
        navigationController.didPopViewControllerPublisher
            .sink { popped, shown in
                XCTAssertTrue(popped === pushedViewController)
                XCTAssertTrue(shown === rootViewController)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        navigationController.popViewController(animated: true)
        waitForExpectations(timeout: Spec.timeout)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.topViewController === rootViewController)
    }

    func testDidPopViewControllerWithThreeControllersInStack() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController

        let firstPushedVC = UIViewController()
        navigationController.pushViewController(firstPushedVC, animated: true)

        let secondPushedVC = UIViewController()
        navigationController.pushViewController(secondPushedVC, animated: true)

        RunLoop.current.run(until: Date())

        XCTAssertEqual(navigationController.viewControllers.count, 3)
        XCTAssertTrue(navigationController.topViewController === secondPushedVC)

        // expectations
        let didPopFirstVCExpectation = XCTestExpectation(description: "didPopViewController - firstPushedVC")
        navigationController.didPopViewControllerPublisher
            .filter { $0.popped === firstPushedVC }
            .first()
            .sink { popped, shown in
                XCTAssertTrue(popped === firstPushedVC)
                XCTAssertTrue(shown === rootViewController)
                didPopFirstVCExpectation.fulfill()
            }
            .store(in: &cancellables)

        let didPopSecondVCExpectation = XCTestExpectation(description: "didPopViewController - secondPushedVC")
        navigationController.didPopViewControllerPublisher
            .filter { $0.popped === secondPushedVC }
            .first()
            .sink { popped, shown in
                XCTAssertTrue(popped === secondPushedVC)
                XCTAssertTrue(shown === firstPushedVC)
                didPopSecondVCExpectation.fulfill()
            }
            .store(in: &cancellables)

        // pop `secondPushedVC`
        navigationController.popViewController(animated: true)
        wait(for: [didPopSecondVCExpectation], timeout: Spec.timeout)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.topViewController === firstPushedVC)

        // pop `firstPushedVC`
        navigationController.popViewController(animated: true)
        wait(for: [didPopFirstVCExpectation], timeout: Spec.timeout)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.topViewController === rootViewController)
    }

    func testDidPopViewControllerWhenPopToRootViewControllerHappens() throws {
        let rootViewController = UIViewController()
        navigationController = BaseNavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController

        let firstPushedVC = UIViewController()
        navigationController.pushViewController(firstPushedVC, animated: true)

        let secondPushedVC = UIViewController()
        navigationController.pushViewController(secondPushedVC, animated: true)

        RunLoop.current.run(until: Date())

        XCTAssertEqual(navigationController.viewControllers.count, 3)
        XCTAssertTrue(navigationController.topViewController === secondPushedVC)

        // expectations
        let invertedDidPopFirstVCExpectation = expectation(description: "didPopViewController - firstPushedVC")
        invertedDidPopFirstVCExpectation.isInverted = true
        navigationController.didPopViewControllerPublisher
            .filter { $0.popped === firstPushedVC }
            .first()
            .sink { _ in
                invertedDidPopFirstVCExpectation.fulfill()
            }
            .store(in: &cancellables)

        let didPopSecondVCExpectation = expectation(description: "didPopViewController - secondPushedVC")
        navigationController.didPopViewControllerPublisher
            .filter { $0.popped === secondPushedVC }
            .first()
            .sink { popped, shown in
                XCTAssertTrue(popped === secondPushedVC)
                XCTAssertTrue(shown === rootViewController)
                didPopSecondVCExpectation.fulfill()
            }
            .store(in: &cancellables)

        // pop to root VC
        navigationController.popToRootViewController(animated: true)
        waitForExpectations(timeout: Spec.timeout)
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
