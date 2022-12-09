//
//  RedFirstViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 30/07/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol RedFirstSceneOutputDelegate: AnyObject {
    func redFirstSceneDidTapNextButton()
}

// MARK: - Module Output

public protocol RedFirstModuleOutput: AnyObject {
    var didTapNextButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class RedFirstViewModel: RedFirstModuleOutput {
    // module output
    public var didTapNextButtonPublisher: AnyPublisher<Void, Never> {
        didTapNextButtonSubject.eraseToAnyPublisher()
    }

    // output
    let title: String
    let description: String

    // input
    func didTapNextButton() {
        didTapNextButtonSubject.send(())
        outputDelegate?.redFirstSceneDidTapNextButton()
    }

    private let didTapNextButtonSubject = PassthroughSubject<Void, Never>()
    private weak var outputDelegate: RedFirstSceneOutputDelegate?

    public init(outputDelegate: RedFirstSceneOutputDelegate?) {
        self.outputDelegate = outputDelegate
        self.title = "First Red Screen"
        self.description = "This is the FIRST screen with RED background colour"
    }
}

// MARK: - View Controller

final class RedFirstViewController: BaseViewController<RedFirstView>, RedFlowInterfaceStateContaining {

    override var content: Content {
        RedFirstView(viewModel: viewModel)
    }

    var state: RedFlowCoordinator.InterfaceState {
        .redFirstScreen
    }

    private let viewModel: RedFirstViewModel

    init(viewModel: RedFirstViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct RedFirstView: View {
    let viewModel: RedFirstViewModel

    var body: some View {
        BasicColorView(
            title: viewModel.title,
            description: viewModel.description,
            color: .red,
            onNext: viewModel.didTapNextButton
        )
    }
}

struct RedFirstView_Previews: PreviewProvider {
    static var previews: some View {
        RedFirstView(viewModel: RedFirstViewModel(outputDelegate: nil))
    }
}
