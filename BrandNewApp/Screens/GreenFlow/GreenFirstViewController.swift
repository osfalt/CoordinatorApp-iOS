//
//  GreenFirstViewController.swift
//  BrandNewApp
//
//  Created by Dre on 31/07/2021.
//

import SwiftUI
import UIKit

protocol GreenFirstViewModelProtocol: AnyObject {
    var didTapNextButton: () -> Void { get }
}

final class GreenFirstViewModel: GreenFirstViewModelProtocol {
    let didTapNextButton: () -> Void
    init(didTapNextButton: @escaping () -> Void) {
        self.didTapNextButton = didTapNextButton
    }
}

final class GreenFirstViewController: BaseViewController<GreenFirstView> {
    let viewModel: GreenFirstViewModelProtocol

    init(viewModel: GreenFirstViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var content: Content {
        GreenFirstView(onNext: viewModel.didTapNextButton)
    }
}

struct GreenFirstView: View {
    let onNext: (() -> Void)?

    var body: some View {
        BasicColorView(
            title: "First Green Screen",
            description: "This is the first screen with GREEN background colour",
            color: .green,
            onNext: onNext
        )
    }
}

struct GreenFirstView_Previews: PreviewProvider {
    static var previews: some View {
        GreenFirstView(onNext: nil)
    }
}
