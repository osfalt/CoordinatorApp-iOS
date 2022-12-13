//
//  GreenFirstViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol GreenFirstSceneOutputDelegate: AnyObject {
    func greenFirstSceneDidTapNextButton()
}

// MARK: - View Model

public final class GreenFirstViewModel {

    // output
    let title: String
    let description: String

    // input
    func didTapNextButton() {
        outputDelegate?.greenFirstSceneDidTapNextButton()
    }

    private weak var outputDelegate: GreenFirstSceneOutputDelegate?
    
    public init(outputDelegate: GreenFirstSceneOutputDelegate?) {
        self.title = "First Green Screen"
        self.description = "This is the FIRST screen with GREEN background colour"
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class GreenFirstViewController: BaseViewController<GreenFirstView> {

    override var content: Content {
        GreenFirstView(viewModel: viewModel)
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
        GreenFirstView(viewModel: GreenFirstViewModel(outputDelegate: nil))
    }
}
