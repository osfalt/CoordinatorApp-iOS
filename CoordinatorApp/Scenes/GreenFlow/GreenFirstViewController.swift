//
//  GreenFirstViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import SwiftUI
import UIKit

protocol GreenFirstViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var didTapNextButton: () -> Void { get }
}

final class GreenFirstViewModel: GreenFirstViewModelProtocol {
    let title: String
    let description: String
    let didTapNextButton: () -> Void

    init(didTapNextButton: @escaping () -> Void) {
        self.title = "First Green Screen"
        self.description = "This is the FIRST screen with GREEN background colour"
        self.didTapNextButton = didTapNextButton
    }
}

final class GreenFirstViewController: BaseViewController<GreenFirstView>, GreenFlowInterfaceStateContaining {
    var state: GreenFlowCoordinator.InterfaceState {
        .greenFirstScreen
    }

    let viewModel: GreenFirstViewModelProtocol

    init(viewModel: GreenFirstViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var content: Content {
        GreenFirstView(viewModel: viewModel)
    }
}

struct GreenFirstView: View {
    let viewModel: GreenFirstViewModelProtocol

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
        GreenFirstView(viewModel: GreenFirstViewModel(didTapNextButton: {}))
    }
}