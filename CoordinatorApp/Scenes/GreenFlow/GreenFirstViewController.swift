//
//  GreenFirstViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol GreenFirstModuleOutput: AnyObject {
    var didTapNextButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class GreenFirstViewModel: GreenFirstModuleOutput {
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
        self.title = "First Green Screen"
        self.description = "This is the FIRST screen with GREEN background colour"
    }
}

// MARK: - View Controller

final class GreenFirstViewController: BaseViewController<GreenFirstView>, GreenFlowInterfaceStateContaining {

    override var content: Content {
        GreenFirstView(viewModel: viewModel)
    }

    var state: GreenFlowCoordinator.InterfaceState {
        .greenFirstScreen
    }

    let viewModel: GreenFirstViewModel

    init(viewModel: GreenFirstViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct GreenFirstView: View {
    let viewModel: GreenFirstViewModel

    var body: some View {
        BasicColorView(
            title: viewModel.title,
            description: viewModel.description,
            color: .green,
            onNext: viewModel.didTapNextButton
        )
    }
}

struct GreenFirstView_Previews: PreviewProvider {
    static var previews: some View {
        GreenFirstView(viewModel: GreenFirstViewModel())
    }
}
