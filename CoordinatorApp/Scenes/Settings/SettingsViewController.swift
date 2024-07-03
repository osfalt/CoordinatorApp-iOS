//
//  SettingsViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 13/12/2022.
//

import SwiftUI
import UIKit

// MARK: - Scene Output

public protocol SettingsSceneOutputDelegate: AnyObject {
    func settingsSceneDidTapProfileDetails()
    func settingsSceneDidLogoutSuccessfully()
}

// MARK: - View Model

public final class SettingsViewModel {
    
    public typealias Interactor = HasAuthorizationServicing

    // output
    let title: String

    // input
    func didTapLogOutButton() {
        interactor.authorizationService.logOut { [weak self] result in
            switch result {
            case .success:
                self?.outputDelegate?.settingsSceneDidLogoutSuccessfully()
            case .failure:
                // show error
                break
            }
        }
    }
    
    func didTapProfileDetailsButton() {
        outputDelegate?.settingsSceneDidTapProfileDetails()
    }

    private let interactor: Interactor
    private weak var outputDelegate: SettingsSceneOutputDelegate?
    
    public init(interactor: Interactor, outputDelegate: SettingsSceneOutputDelegate?) {
        self.title = "Settings Screen"
        self.interactor = interactor
        self.outputDelegate = outputDelegate
    }
}

// MARK: - View Controller

final class SettingsViewController: BaseViewController<SettingsView> {

    override var content: Content {
        SettingsView(viewModel: viewModel)
    }

    let viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct SettingsView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 24) {
            Button("Open Profile Details", action: viewModel.didTapProfileDetailsButton)
            Button("Log Out", action: viewModel.didTapLogOutButton)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(interactor: AppDependencies(), outputDelegate: nil))
    }
}
