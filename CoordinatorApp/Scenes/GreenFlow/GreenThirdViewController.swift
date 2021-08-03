//
//  GreenThirdViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 04/08/2021.
//

import SwiftUI
import UIKit

protocol GreenThirdViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var dynamicText: String? { get }
    var didTapNextButton: () -> Void { get }
}

final class GreenThirdViewModel: GreenThirdViewModelProtocol {
    let title: String
    let description: String
    let dynamicText: String?
    let didTapNextButton: () -> Void

    init(dynamicText: String? = nil, didTapNextButton: @escaping () -> Void) {
        self.title = "Third Green Screen"
        self.description = "This is the THIRD screen with GREEN background colour"
        self.dynamicText = dynamicText
        self.didTapNextButton = didTapNextButton
    }
}

final class GreenThirdViewController: BaseViewController<AnyView>, GreenFlowInterfaceStateContaining {
    var state: GreenFlowCoordinator.InterfaceState {
        .greenThirdScreen(nil)
    }
    
    let viewModel: GreenThirdViewModelProtocol

    init(viewModel: GreenThirdViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
}

struct GreenThirdView: View {
    let viewModel: GreenThirdViewModelProtocol

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
        GreenThirdView(viewModel: GreenThirdViewModel(didTapNextButton: {}))
    }
}
