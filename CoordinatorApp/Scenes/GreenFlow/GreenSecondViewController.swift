//
//  GreenSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 03/08/2021.
//

import SwiftUI
import UIKit

public protocol GreenSecondViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var didTapNextButton: () -> Void { get }
}

public final class GreenSecondViewModel: GreenSecondViewModelProtocol {
    public let title: String
    public let description: String
    public let didTapNextButton: () -> Void

    public init(didTapNextButton: @escaping () -> Void) {
        self.title = "Second Green Screen"
        self.description = "This is the SECOND screen with GREEN background colour"
        self.didTapNextButton = didTapNextButton
    }
}

final class GreenSecondViewController: BaseViewController<GreenSecondView>, GreenFlowInterfaceStateContaining {

    override var content: Content {
        GreenSecondView(viewModel: viewModel)
    }

    var state: GreenFlowCoordinator.InterfaceState {
        .greenSecondScreen
    }
    
    let viewModel: GreenSecondViewModelProtocol

    init(viewModel: GreenSecondViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct GreenSecondView: View {
    let viewModel: GreenSecondViewModelProtocol

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
        GreenSecondView(viewModel: GreenSecondViewModel(didTapNextButton: {}))
    }
}
