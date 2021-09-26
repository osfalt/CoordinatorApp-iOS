//
//  GreenSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol GreenSecondModuleOutput: AnyObject {
    var didTapNextButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class GreenSecondViewModel: GreenSecondModuleOutput {
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
        self.title = "Second Green Screen"
        self.description = "This is the SECOND screen with GREEN background colour"
    }
}

final class GreenSecondViewController: BaseViewController<GreenSecondView>, GreenFlowInterfaceStateContaining {

    override var content: Content {
        GreenSecondView(viewModel: viewModel)
    }

    var state: GreenFlowCoordinator.InterfaceState {
        .greenSecondScreen
    }
    
    let viewModel: GreenSecondViewModel

    init(viewModel: GreenSecondViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct GreenSecondView: View {
    let viewModel: GreenSecondViewModel

    var body: some View {
        BasicColorView(
            title: viewModel.title,
            description: viewModel.description,
            color: .green,
            onNext: viewModel.didTapNextButton
        )
    }
}

struct GreenSecondView_Previews: PreviewProvider {
    static var previews: some View {
        GreenSecondView(viewModel: GreenSecondViewModel())
    }
}
