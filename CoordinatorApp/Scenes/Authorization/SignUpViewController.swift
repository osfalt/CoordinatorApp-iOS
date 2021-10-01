//
//  SignUpViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol SignUpModuleOutput: AnyObject {
    var didTapSignUpButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class SignUpViewModel: SignUpModuleOutput {
    // module output
    public var didTapSignUpButtonPublisher: AnyPublisher<Void, Never> {
        didTapSignUpButtonSubject.eraseToAnyPublisher()
    }

    // output
    let title: String

    // input
    func didTapSignUpButton() {
        didTapSignUpButtonSubject.send(())
    }

    private let didTapSignUpButtonSubject = PassthroughSubject<Void, Never>()

    public init() {
        self.title = "Sign-Up Screen"
    }
}

// MARK: - View Controller

final class SignUpViewController: BaseViewController<SignUpView>, AuthorizationInterfaceStateContaining {

    override var content: Content {
        SignUpView(viewModel: viewModel)
    }

    var state: AuthorizationCoordinator.InterfaceState {
        .signUp
    }

    let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct SignUpView: View {
    let viewModel: SignUpViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.title).font(.title)
            Button("Sign Up", action: viewModel.didTapSignUpButton)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
