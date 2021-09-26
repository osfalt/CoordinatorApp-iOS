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

public final class RedDynamicInfoViewModel: ObservableObject {
    // output
    @Published private(set) var items: [DynamicInfoItem] = []
    @Published private(set) var isLoading = false
    @Published var showError: Bool = false

    // input
    public func viewDidLoad() {
        loadItems()
    }

    public func didTapReloadButton() {
        loadItems()
    }

    public func didSelectCell(_ item: DynamicInfoItem) {
        print("didSelectCell -> \(item.title)")
    }

    private let fetcher: DynamicItemsFetchable
    private var cancellables: Set<AnyCancellable> = []

    public init(fetcher: DynamicItemsFetchable) {
        self.fetcher = fetcher
    }

    private func loadItems() {
        isLoading = true
        items = []

        fetcher.fetchItems
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    guard case .failure = completion else { return }
                    self?.showError = true
                },
                receiveValue: { [weak self] items in
                    self?.items = items
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - View Controller

final class RedDynamicInfoViewController: BaseViewController<RedDynamicInfoView>, RedFlowInterfaceStateContaining {

    override var content: Content {
        RedDynamicInfoView(viewModel: viewModel)
    }

    var state: RedFlowCoordinator.InterfaceState {
        .redDynamicInfoScreen
    }

    private let viewModel: RedDynamicInfoViewModel

    init(viewModel: RedDynamicInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Red Dynamic Info Screen"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct RedDynamicInfoView: View {
    @ObservedObject var viewModel: RedDynamicInfoViewModel
    @State private var viewAppeared = false

    var body: some View {
        VStack {
            ZStack {
                List(viewModel.items) { item in
                    ListCell(
                        text: item.title,
                        action: { viewModel.didSelectCell(item) }
                    )
                }
                .listStyle(.plain)
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            Button("Reload", action: viewModel.didTapReloadButton)
                .foregroundColor(.white)
                .disabled(viewModel.isLoading)
                .padding()
        }
        .background(Color.red)
        .onAppear {
            guard !viewAppeared else { return }
            viewAppeared = true
            viewModel.viewDidLoad()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"))
        }
    }
}

struct RedDynamicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RedDynamicInfoView(viewModel: RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher()))
    }
}
