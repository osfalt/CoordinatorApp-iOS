//
//  BaseNavigationController.swift
//  BrandNewApp
//
//  Created by Dre on 02/08/2021.
//

import UIKit

open class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {

    public var didPopViewController: ((UIViewController) -> Void)?

    open override var delegate: UINavigationControllerDelegate? {
        get { proxyDelegate }
        set { proxyDelegate = newValue }
    }

    private weak var proxyDelegate: UINavigationControllerDelegate?
    private lazy var storedChildsCount = viewControllers.count
    private weak var storedTopViewController: UIViewController?

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
            didPopViewController?(storedTopViewController)
        }

        storedChildsCount = viewControllers.count
        storedTopViewController = topViewController
    }

}
