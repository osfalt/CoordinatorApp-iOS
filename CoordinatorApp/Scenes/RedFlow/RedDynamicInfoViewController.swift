//
//  RedDynamicInfoViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 09/08/2021.
//

import Combine
import SwiftUI
import UIKit

// MARK: - View Model

protocol RedDynamicInfoViewModelProtocol: ObservableObject {
    var items: [DynamicInfoItem] { get }
    var isLoading: Bool { get }
    func didTapReloadButton()
}

final class RedDynamicInfoViewModel: RedDynamicInfoViewModelProtocol {
    @Published private(set) var items: [DynamicInfoItem] = []
    @Published private(set) var isLoading = false
    private let fetcher: DynamicItemsFetchable
    private var cancellables: Set<AnyCancellable> = []

    init(fetcher: DynamicItemsFetchable) {
        self.fetcher = fetcher
        loadItems()
    }

    func didTapReloadButton() {
        loadItems()
    }

    private func loadItems() {
        isLoading = true
        items = []

        fetcher.fetchItems
            .sink(
                receiveCompletion: { completion in
                    guard case .failure(let error) = completion else { return }
                    // TODO: show error
                    print("Error = \(error)")
                },
                receiveValue: { [weak self] items in
                    guard let self = self else { return }
                    self.items = items
                    self.isLoading = false
                }
            )
            .store(in: &cancellables)
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
        RedDynamicInfoView(viewModel: RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher()))
    }
}
