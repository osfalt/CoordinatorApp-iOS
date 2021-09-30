//
//  BaseNavigationController.swift
//  CoordinatorApp
//
//  Created by Dre on 02/08/2021.
//

import Combine
import UIKit

open class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {

    // MARK: - Public

    public var didPopViewControllerPublisher: AnyPublisher<(popped: UIViewController, shown: UIViewController), Never> {
        didPopViewControllerSubject.eraseToAnyPublisher()
    }

    open override var delegate: UINavigationControllerDelegate? {
        get { proxyDelegate }
        set { proxyDelegate = newValue }
    }

    public var animationEnabled: Bool?

    // MARK: - Private

    private weak var proxyDelegate: UINavigationControllerDelegate?
    private lazy var storedChildsCount = viewControllers.count
    private weak var storedTopViewController: UIViewController?
    private let didPopViewControllerSubject = PassthroughSubject<(popped: UIViewController, shown: UIViewController), Never>()

    // MARK: - Init

    public init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        super.delegate = self
    }

    // MARK: - Overrides

    @discardableResult
    open override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animationEnabled ?? animated)
    }

    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return super.popToViewController(viewController, animated: animationEnabled ?? animated)
    }

    @discardableResult
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animationEnabled ?? animated)
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        proxyDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        proxyDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)

        let isPop = viewControllers.count < storedChildsCount
        if isPop, let storedTopViewController = storedTopViewController {
            didPopViewControllerSubject.send((popped: storedTopViewController, shown: viewController))
        }

        storedChildsCount = viewControllers.count
        storedTopViewController = topViewController
    }

}
