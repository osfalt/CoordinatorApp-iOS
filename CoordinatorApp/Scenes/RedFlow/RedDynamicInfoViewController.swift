//
//  RedDynamicInfoViewController.swift
//  CoordinatorApp
//
//  Created by Dre on 09/08/2021.
//

import Combine
import SwiftUI
import UIKit

public struct RedDynamicInfoItem: Identifiable, Equatable {
    public let id: Int
    public let title: String
}

// MARK: - Scene Output

public protocol RedDynamicInfoSceneOutputDelegate: AnyObject {
    func redDynamicInfoSceneDidSelectItem(_ item: RedDynamicInfoItem)
    func redDynamicInfoSceneDidTapBackButton()
}

// MARK: - View Model

public final class RedDynamicInfoViewModel: ObservableObject {
    
    // output
    @Published private(set) var items: [RedDynamicInfoItem] = []
    @Published private(set) var isLoading = false
    @Published var showError: Bool = false

    // input
    func viewDidLoad() {
        loadItems()
    }

    func didTapReloadButton() {
        loadItems()
    }

    func didSelectCell(_ item: RedDynamicInfoItem) {
        didSelectItemSubject.send(item)
        outputDelegate?.redDynamicInfoSceneDidSelectItem(item)
    }
    
    func didTapBackButton() {
        outputDelegate?.redDynamicInfoSceneDidTapBackButton()
    }

    private let fetcher: DynamicItemsFetchable
    private var cancellables: Set<AnyCancellable> = []
    private let didSelectItemSubject = PassthroughSubject<RedDynamicInfoItem, Never>()
    private weak var outputDelegate: RedDynamicInfoSceneOutputDelegate?
    
    public init(fetcher: DynamicItemsFetchable, outputDelegate: RedDynamicInfoSceneOutputDelegate?) {
        self.fetcher = fetcher
        self.outputDelegate = outputDelegate
    }

    private func loadItems() {
        isLoading = true
        items = []

        fetcher.fetchItems
            .map { fetchedItems in
                fetchedItems.map { RedDynamicInfoItem(id: $0.index, title: $0.name) }
            }
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

final class RedDynamicInfoViewController: BaseViewController<RedDynamicInfoView> {

    override var content: Content {
        RedDynamicInfoView(viewModel: viewModel)
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
    
    override func didTapBackButton() {
        viewModel.didTapBackButton()
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
        RedDynamicInfoView(viewModel: RedDynamicInfoViewModel(fetcher: DynamicItemsFetcher(), outputDelegate: nil))
    }
}
