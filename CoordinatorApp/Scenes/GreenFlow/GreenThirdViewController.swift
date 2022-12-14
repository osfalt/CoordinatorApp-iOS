//
//  GreenThirdViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 04/08/2021.
//

import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol GreenThirdSceneOutputDelegate: AnyObject {
    func greenThirdSceneDidTapNextButton()
    func greenThirdSceneDidTapBackButton()
}

// MARK: - View Model

public final class GreenThirdViewModel {

    // output
    let title: String
    let description: String
    let dynamicText: String?

    // input
    func didTapNextButton() {
        outputDelegate?.greenThirdSceneDidTapNextButton()
    }
    
    func didTapBackButton() {
        outputDelegate?.greenThirdSceneDidTapBackButton()
    }

    private weak var outputDelegate: GreenThirdSceneOutputDelegate?

    public init(dynamicText: String? = nil, outputDelegate: GreenThirdSceneOutputDelegate?) {
        self.title = "Third Green Screen"
        self.description = "This is the THIRD screen with GREEN background colour"
        self.dynamicText = dynamicText
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class GreenThirdViewController: BaseViewController<AnyView> {

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
    
    let viewModel: GreenThirdViewModel

    init(viewModel: GreenThirdViewModel) {
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
        GreenThirdView(viewModel: GreenThirdViewModel(outputDelegate: nil))
    }
}
