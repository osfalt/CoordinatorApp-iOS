//
//  RedFirstViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 30/07/2021.
//

import SwiftUI
import UIKit

protocol RedFirstViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var didTapNextButton: () -> Void { get }
}

final class RedFirstViewModel: RedFirstViewModelProtocol {
    let title: String
    let description: String
    let didTapNextButton: () -> Void

    init(didTapNextButton: @escaping () -> Void) {
        self.title = "First Red Screen"
        self.description = "This is the FIRST screen with RED background colour"
        self.didTapNextButton = didTapNextButton
    }
}

final class RedFirstViewController: BaseViewController<RedFirstView>, RedFlowInterfaceStateContaining {
    
    override var content: Content {
        RedFirstView(viewModel: viewModel)
    }

    var state: RedFlowCoordinator.InterfaceState {
        .redFirstScreen
    }

    let viewModel: RedFirstViewModelProtocol

    init(viewModel: RedFirstViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RedFirstView: View {
    let viewModel: RedFirstViewModelProtocol

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
        RedFirstView(viewModel: RedFirstViewModel(didTapNextButton: {}))
    }
}
