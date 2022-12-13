//
//  GreenSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol GreenSecondSceneOutputDelegate: AnyObject {
    func greenSecondSceneDidTapNextButton()
    func greenSecondSceneDidTapBackButton()
}

// MARK: - View Model

public final class GreenSecondViewModel {

    // output
    let title: String
    let description: String

    // input
    func didTapNextButton() {
        outputDelegate?.greenSecondSceneDidTapNextButton()
    }
    
    func didTapBackButton() {
        outputDelegate?.greenSecondSceneDidTapBackButton()
    }

    private weak var outputDelegate: GreenSecondSceneOutputDelegate?
    
    public init(outputDelegate: GreenSecondSceneOutputDelegate?) {
        self.title = "Second Green Screen"
        self.description = "This is the SECOND screen with GREEN background colour"
        self.outputDelegate = outputDelegate
    }
}

final class GreenSecondViewController: BaseViewController<GreenSecondView> {

    override var content: Content {
        GreenSecondView(viewModel: viewModel)
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
    
    override func didTapBackButton() {
        viewModel.didTapBackButton()
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
        GreenSecondView(viewModel: GreenSecondViewModel(outputDelegate: nil))
    }
}
