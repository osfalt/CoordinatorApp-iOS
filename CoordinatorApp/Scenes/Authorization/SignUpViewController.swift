//
//  SignUpViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 28/09/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol SignUpSceneOutputDelegate: AnyObject {
    func signInSceneDidRegisterSuccessfully()
    func signUpSceneDidTapBackButton()
}

// MARK: - View Model

public final class SignUpViewModel {
    
    public typealias Interactor = HasAuthorizationServicing

    // output
    let title: String

    // input
    func didTapSignUpButton() {
        didTapSignUpButtonSubject.send(())
                
        interactor.authorizationService.registerUser { [weak self] result in
            switch result {
            case .success:
                self?.outputDelegate?.signInSceneDidRegisterSuccessfully()
            case .failure:
                // show error
                break
            }
        }
    }
    
    func didTapBackButton() {
        outputDelegate?.signUpSceneDidTapBackButton()
    }

    private let didTapSignUpButtonSubject = PassthroughSubject<Void, Never>()
    
    private let interactor: Interactor
    private weak var outputDelegate: SignUpSceneOutputDelegate?
    
    public init(interactor: Interactor, outputDelegate: SignUpSceneOutputDelegate?) {
        self.title = "Sign-Up Screen"
        self.interactor = interactor
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class SignUpViewController: BaseViewController<SignUpView> {

    override var content: Content {
        SignUpView(viewModel: viewModel)
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
    
    override func didTapBackButton() {
        viewModel.didTapBackButton()
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
        SignUpView(viewModel: SignUpViewModel(interactor: AppDependencies(), outputDelegate: nil))
    }
}
