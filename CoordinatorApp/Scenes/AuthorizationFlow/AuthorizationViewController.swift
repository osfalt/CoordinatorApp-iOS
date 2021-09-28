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

public protocol AuthorizationModuleOutput: AnyObject {
    var didTapSignInButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class AuthorizationViewModel: AuthorizationModuleOutput {
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
        self.title = "Authorization Screen"
    }
}

// MARK: - View Controller

final class AuthorizationViewController: BaseViewController<AuthorizationView> {

    override var content: Content {
        AuthorizationView(viewModel: viewModel)
    }

    let viewModel: AuthorizationViewModel

    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct AuthorizationView: View {
    let viewModel: AuthorizationViewModel

    var body: some View {
        VStack {
            Text(viewModel.title)
            Button("Sign In", action: viewModel.didTapSignInButton)
        }
    }
}

struct _Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(viewModel: AuthorizationViewModel())
    }
}
