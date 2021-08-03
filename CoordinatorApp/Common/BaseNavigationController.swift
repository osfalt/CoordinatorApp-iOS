//
//  BaseNavigationController.swift
//  CoordinatorApp
//
//  Created by Dre on 02/08/2021.
//

import Combine
import UIKit

open class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {

    public var didPopViewControllerPublisher: AnyPublisher<(popped: UIViewController, shown: UIViewController), Never> {
        didPopViewControllerSubject.eraseToAnyPublisher()
    }

    open override var delegate: UINavigationControllerDelegate? {
        get { proxyDelegate }
        set { proxyDelegate = newValue }
    }

    private weak var proxyDelegate: UINavigationControllerDelegate?
    private lazy var storedChildsCount = viewControllers.count
    private weak var storedTopViewController: UIViewController?
    private let didPopViewControllerSubject = PassthroughSubject<(popped: UIViewController, shown: UIViewController), Never>()

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

    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
//        print("🦝 WILL show viewController: \(viewController), count: \(viewControllers.count)")
        proxyDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
//        print("🦝 DID show viewController: \(viewController), count: \(viewControllers.count), storedTopViewController: \(storedTopViewController)")
        proxyDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)

        let isPop = viewControllers.count < storedChildsCount
        if isPop, let storedTopViewController = storedTopViewController {
            didPopViewControllerSubject.send((popped: storedTopViewController, shown: viewController))
        }

        storedChildsCount = viewControllers.count
        storedTopViewController = topViewController
    }

}
