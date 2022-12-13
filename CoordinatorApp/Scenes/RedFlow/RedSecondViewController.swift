//
//  RedSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 01/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol RedSecondSceneOutputDelegate: AnyObject {
    func redSecondSceneDidTapNextButton()
    func redSecondSceneDidTapBackButton()
}

// MARK: - View Model

public final class RedSecondViewModel {

    // output
    let title: String
    let description: String

    // input
    func didTapNextButton() {
        didTapNextButtonSubject.send(())
        outputDelegate?.redSecondSceneDidTapNextButton()
    }
    
    func didTapBackButton() {
        outputDelegate?.redSecondSceneDidTapBackButton()
    }

    private let didTapNextButtonSubject = PassthroughSubject<Void, Never>()
    private weak var outputDelegate: RedSecondSceneOutputDelegate?

    public init(outputDelegate: RedSecondSceneOutputDelegate?) {
        self.outputDelegate = outputDelegate
        self.title = "Second Red Screen"
        self.description = "This is the SECOND screen with RED background colour"
    }
}

// MARK: - View Controller

final class RedSecondViewController: BaseViewController<RedSecondView> {

    override var content: Content {
        RedSecondView(viewModel: viewModel)
    }
    
    private let viewModel: RedSecondViewModel

    init(viewModel: RedSecondViewModel) {
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
        RedSecondView(viewModel: RedSecondViewModel(outputDelegate: nil))
    }
}
