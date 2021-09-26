//
//  RedSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 01/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol RedSecondModuleOutput: AnyObject {
    var didTapNextButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class RedSecondViewModel: RedSecondModuleOutput {
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
    }

    private let didTapNextButtonSubject = PassthroughSubject<Void, Never>()

    public init() {
        self.title = "Second Red Screen"
        self.description = "This is the SECOND screen with RED background colour"
    }
}

// MARK: - View Controller

final class RedSecondViewController: BaseViewController<RedSecondView>, RedFlowInterfaceStateContaining {

    override var content: Content {
        RedSecondView(viewModel: viewModel)
    }

    var state: RedFlowCoordinator.InterfaceState {
        .redSecondScreen
    }
    
    let viewModel: RedSecondViewModel

    init(viewModel: RedSecondViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct RedSecondView: View {
    let viewModel: RedSecondViewModel

    var body: some View {
        BasicColorView(
            title: viewModel.title,
            description: viewModel.description,
            color: .red,
            onNext: viewModel.didTapNextButton
        )
    }
}

struct RedSecondView_Previews: PreviewProvider {
    static var previews: some View {
        RedSecondView(viewModel: RedSecondViewModel())
    }
}
