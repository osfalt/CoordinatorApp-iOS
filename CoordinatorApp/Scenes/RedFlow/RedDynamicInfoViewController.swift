//
//  RedDynamicInfoViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 09/08/2021.
//

import SwiftUI
import UIKit

public struct DynamicInfoItem: Identifiable {
    public var id: Int { title.hashValue }
    public let title: String
}

// MARK: - View Model

protocol RedDynamicInfoViewModelProtocol: ObservableObject {
    var items: [DynamicInfoItem] { get }
    var isLoading: Bool { get }
    func didTapReloadButton()
}

final class RedDynamicInfoViewModel: RedDynamicInfoViewModelProtocol {
    @Published private(set) var items: [DynamicInfoItem] = []
    @Published private(set) var isLoading = false

    init() {
        loadItems()
    }

    func didTapReloadButton() {
        loadItems()
    }

    private func loadItems() {
        isLoading = true
        items = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            items = [
                .init(title: "First Item"),
                .init(title: "Second Item"),
                .init(title: "Third Item"),
                .init(title: "Fourth Item"),
                .init(title: "Fifth Item"),
                .init(title: "Sixth Item"),
                .init(title: "Seventh Item"),
                .init(title: "Eighth Item"),
                .init(title: "Ninth Item"),
                .init(title: "Tenth Item"),
            ]
            isLoading = false
        }
    }
}

// MARK: - View Controller

final class RedDynamicInfoViewController<ViewModel>: BaseViewController<RedDynamicInfoView<ViewModel>>, RedFlowInterfaceStateContaining where ViewModel: RedDynamicInfoViewModelProtocol {

    var state: RedFlowCoordinator.InterfaceState {
        .redDynamicInfoScreen
    }

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Red Dynamic Info Screen"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var content: Content {
        RedDynamicInfoView(viewModel: viewModel)
    }
}

// MARK: - View

struct RedDynamicInfoView<ViewModel>: View where ViewModel: RedDynamicInfoViewModelProtocol {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            ZStack {
                List(viewModel.items) { item in
                    Text(item.title)
                }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            Button("Reload", action: viewModel.didTapReloadButton)
                .disabled(viewModel.isLoading)
                .padding()
        }
    }
}

struct RedDynamicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RedDynamicInfoView(viewModel: RedDynamicInfoViewModel())
    }
}
