//
//  GreenThirdViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 04/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Module Output

public protocol GreenThirdModuleOutput: AnyObject {
    var didTapNextButtonPublisher: AnyPublisher<Void, Never> { get }
}

// MARK: - View Model

public final class GreenThirdViewModel: GreenThirdModuleOutput {
    // module output
    public var didTapNextButtonPublisher: AnyPublisher<Void, Never> {
        didTapNextButtonSubject.eraseToAnyPublisher()
    }

    // output
    let title: String
    let description: String
    let dynamicText: String?

    // input
    func didTapNextButton() {
        didTapNextButtonSubject.send(())
    }

    private let didTapNextButtonSubject = PassthroughSubject<Void, Never>()

    public init(dynamicText: String? = nil) {
        self.title = "Third Green Screen"
        self.description = "This is the THIRD screen with GREEN background colour"
        self.dynamicText = dynamicText
    }
}

// MARK: - View Controller

final class GreenThirdViewController: BaseViewController<AnyView>, GreenFlowInterfaceStateContaining {

    override var content: Content {
        AnyView(
            ZStack(alignment: .top) {
                GreenThirdView(viewModel: viewModel)
                if let dynamicText = viewModel.dynamicText {
                    Text(dynamicText)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.purple)
                        .padding()
                }
            }
        )
    }

    var state: GreenFlowCoordinator.InterfaceState {
        .greenThirdScreen(nil)
    }
    
    let viewModel: GreenThirdViewModel

    init(viewModel: GreenThirdViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct GreenThirdView: View {
    let viewModel: GreenThirdViewModel

    var body: some View {
        BasicColorView(
            title: viewModel.title,
            description: viewModel.description,
            color: .green,
            onNext: viewModel.didTapNextButton
        )
    }
}

struct GreenThirdView_Previews: PreviewProvider {
    static var previews: some View {
        GreenThirdView(viewModel: GreenThirdViewModel())
    }
}
