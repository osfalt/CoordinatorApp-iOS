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
    
    public var didPopViewControllerPublisher: AnyPublisher<UIViewController, Never> {
        didPopViewControllerSubject.eraseToAnyPublisher()
    }
    
    open override var delegate: UINavigationControllerDelegate? {
        get { proxyDelegate }
        set { proxyDelegate = newValue }
    }
    
    public var animationEnabled: Bool?
    
    // MARK: - Private
    
    private weak var proxyDelegate: UINavigationControllerDelegate?
    private var viewControllersBeforePop: [UIViewController] = []
    private let didPopViewControllerSubject = PassthroughSubject<UIViewController, Never>()
    
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
        viewControllersBeforePop = viewControllers
        return super.popViewController(animated: animated)
    }
    
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        viewControllersBeforePop = viewControllers
        return super.popToViewController(viewController, animated: animated)
    }
    
    @discardableResult
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        viewControllersBeforePop = viewControllers
        return super.popToRootViewController(animated: animated)
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
        
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        let isPop = !navigationController.viewControllers.contains(fromVC)
        guard isPop else {
            return
        }
        
        let viewControllersToPop: [UIViewController] = {
            var viewControllersToPop: [UIViewController] = []
            let diff = viewControllersBeforePop.difference(from: navigationController.viewControllers)
            for change in diff {
                switch change {
                case .insert(_, let element, _):
                    viewControllersToPop.append(element)
                case .remove:
                    break
                }
            }
            return viewControllersToPop.reversed()
        }()
        
        viewControllersBeforePop = []
        
        for popVC in viewControllersToPop {
            didPopViewControllerSubject.send(popVC)
        }
    }
    
}
