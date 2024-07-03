//
//  ProfileDetailsViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 03/07/2024.
//

import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol ProfileDetailsSceneOutputDelegate: AnyObject {
    func profileDetailsSceneDidTapCloseButton()
}

// MARK: - View Model

public final class ProfileDetailsViewModel {
    
    // output
    let name: String

    // input
    func didTapCloseButton() {
        outputDelegate?.profileDetailsSceneDidTapCloseButton()
    }

    private weak var outputDelegate: ProfileDetailsSceneOutputDelegate?
    
    public init(outputDelegate: ProfileDetailsSceneOutputDelegate?) {
        self.name = "User Name"
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class ProfileDetailsViewController: BaseViewController<ProfileDetailsView> {

    override var content: Content {
        ProfileDetailsView(viewModel: viewModel)
    }

    let viewModel: ProfileDetailsViewModel

    init(viewModel: ProfileDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct ProfileDetailsView: View {
    let viewModel: ProfileDetailsViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.name)
            Button("Close", action: viewModel.didTapCloseButton)
        }
    }
}

struct ProfileDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsView(viewModel: ProfileDetailsViewModel(outputDelegate: nil))
    }
}
