//
//  AuthorizationViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol SignInModuleOutput: AnyObject {
    var didTapSignInButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class SignInViewModel: SignInModuleOutput {
    // module output
    public var didTapSignInButtonPublisher: AnyPublisher<Void, Never> {
        didTapSignInButtonSubject.eraseToAnyPublisher()
    }

    // output
    let title: String

    // input
    func didTapSignInButton() {
        didTapSignInButtonSubject.send(())
    }

    private let didTapSignInButtonSubject = PassthroughSubject<Void, Never>()

    public init() {
        self.title = "Sign-In Screen"
    }
}

// MARK: - View Controller

final class SignInViewController: BaseViewController<SignInView>, AuthorizationInterfaceStateContaining {

    override var content: Content {
        SignInView(viewModel: viewModel)
    }

    var state: AuthorizationCoordinator.InterfaceState {
        .signIn
    }

    let viewModel: SignInViewModel

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct SignInView: View {
    let viewModel: SignInViewModel

    var body: some View {
        VStack {
            Text(viewModel.title)
            Button("Sign In", action: viewModel.didTapSignInButton)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
