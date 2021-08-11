//
//  RedSecondViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 01/08/2021.
//

import SwiftUI
import UIKit

public protocol RedSecondViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var didTapNextButton: () -> Void { get }
}

public final class RedSecondViewModel: RedSecondViewModelProtocol {
    public let title: String
    public let description: String
    public let didTapNextButton: () -> Void
    
    public init(didTapNextButton: @escaping () -> Void) {
        self.title = "Second Red Screen"
        self.description = "This is the SECOND screen with RED background colour"
        self.didTapNextButton = didTapNextButton
    }
}

final class RedSecondViewController: BaseViewController<RedSecondView>, RedFlowInterfaceStateContaining {

    override var content: Content {
        RedSecondView(viewModel: viewModel)
    }

    var state: RedFlowCoordinator.InterfaceState {
        .redSecondScreen
    }
    
    let viewModel: RedSecondViewModelProtocol

    init(viewModel: RedSecondViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RedSecondView: View {
    let viewModel: RedSecondViewModelProtocol

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
        RedSecondView(viewModel: RedSecondViewModel(didTapNextButton: {}))
    }
}
