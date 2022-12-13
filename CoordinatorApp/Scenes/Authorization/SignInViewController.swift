//
//  AuthorizationViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol SignInSceneOutputDelegate: AnyObject {
    func signInSceneDidLogInSuccessfully()
    func signInSceneDidTapCreateAccountButton()
}

// MARK: - View Model

public final class SignInViewModel {
    
    public typealias Interactor = HasAuthorizationServicing

    // output
    let title: String

    // input
    func didTapSignInButton() {
        didTapSignInButtonSubject.send(())
        
        interactor.authorizationService.logInUser { [weak self] result in
            switch result {
            case .success:
                self?.outputDelegate?.signInSceneDidLogInSuccessfully()
            case .failure:
                // show error
                break
            }
        }
    }

    func didTapCreateAccountButton() {
        didTapCreateAccountButtonSubject.send(())
        outputDelegate?.signInSceneDidTapCreateAccountButton()
    }

    private let didTapSignInButtonSubject = PassthroughSubject<Void, Never>()
    private let didTapCreateAccountButtonSubject = PassthroughSubject<Void, Never>()
    
    private let interactor: Interactor
    private weak var outputDelegate: SignInSceneOutputDelegate?
    
    public init(interactor: Interactor, outputDelegate: SignInSceneOutputDelegate?) {
        self.title = "Sign-In Screen"
        self.interactor = interactor
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class SignInViewController: BaseViewController<SignInView> {

    override var content: Content {
        SignInView(viewModel: viewModel)
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
        VStack(spacing: 16) {
            Text(viewModel.title).font(.title)
            Button("Sign In", action: viewModel.didTapSignInButton)

            Spacer(minLength: 32).fixedSize()

            Text("Don't have an account?")
            Button("Create account", action: viewModel.didTapCreateAccountButton)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(interactor: AppDependencies(), outputDelegate: nil))
    }
}
