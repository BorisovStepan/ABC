//
//  MainPage.ViewModel.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Network
import Foundation

extension MainPage {
    
    final public class ViewModel: ObservableObject {
        
        @Published var state: State = .initial
        private let networkClient: NetworkClientProtocol
        private var sections: [ContentSection] = []
        private var updateCellsTask: Task<Void, Never>?
        private var loadDataTask: Task<Void, Never>?
        private var filterCellsTask: Task<Void, Never>?
        let stateUpdateQueue: DispatchQueue = .init(label: "StateUpdateQueue")
        
        public init(networkClient: NetworkClientProtocol) {
            self.networkClient = networkClient
        }
        
        func dispatch(_ action: Action) {
            switch action {
                
            case .viewDidLoad:
                loadData()
                
            case .didSelectPage(let index):
                guard index != state.selectedPage else { return }
                updateState { $0.selectedPage = index }
                updateCells(with: index)
                
            case .didChangeSearchText(let text):
                guard text != state.searchText else { return }
                filterCells(with: text)
                
            case .showStatistic:
                guard !state.shouldShowStatistic else { return }
                prepareStatistic()
                
            case .dismiss:
                updateState {
                    $0.shouldShowStatistic = false
                    $0.context = nil
                }
                
            case .dismissError:
                updateState { $0.error = .init() }
            }
        }
     
        private func loadData() {
            loadDataTask?.cancel()
            loadDataTask = Task { [weak self] in
                do {
                    if let sections = try await self?.networkClient.fetchData() {
                        guard !Task.isCancelled else { return }
                        self?.sections = sections
                        self?.updateCells(with: .zero)
                        self?.updateHeader()
                    }
                } catch {
                    self?.updateState { $0.error = error.localizedDescription }
                }
            }
        }
        
        private func updateHeader() {
            Task { [weak self] in
                guard let self else { return }
                
                var headersImages: [Data] = []
                for item in sections {
                    if let data = try? await networkClient.fetchImageData(from: item.imageUrl) {
                        headersImages.append(data)
                    }
                }
                
                updateState { $0.headerImages = headersImages }
            }
        }
        
        private func getCellAttribute(item: ContentItem) async -> View.ListCell.Attribute {
            let data = try? await networkClient.fetchImageData(from: item.imageUrl)
            
            return .init(
                title: item.title,
                subtitle: item.subtitle,
                image: data ?? Data()
            )
        }
    
        private func updateCells(with index: Int) {
            updateCellsTask?.cancel()
            filterCellsTask?.cancel()
            updateCellsTask = Task { [weak self] in
                guard
                    let self,
                    let items = sections[safe: index]?.items
                else { return }
                
                let cells: [View.ListCell.Attribute] = await withTaskGroup(
                    of: (Int, View.ListCell.Attribute?).self,
                    returning: [View.ListCell.Attribute].self
                ) { group in
                    
                    for (index, item) in items.enumerated() {
                        group.addTask { [weak self] in
                            guard !Task.isCancelled else { return (index, nil) }
                            
                            let cell = await self?.getCellAttribute(item: item)
                            return (index, cell)
                        }
                    }
                    
                    var result = Array<View.ListCell.Attribute?>(
                        repeating: nil,
                        count: items.count
                    )
                    
                    for await (index, cell) in group {
                        guard !Task.isCancelled else { return [] }
                        
                        result[index] = cell
                    }
                    
                    return result.compactMap { $0 }
                }
                
                guard !Task.isCancelled else { return }
                
                updateState {
                    guard $0.selectedPage == index else { return }
                    $0.cells = cells
                    $0.searchText = .init()
                }
            }
        }
        
        private func filterCells(with text: String) {
            guard
                !text.isEmpty,
                let items = sections[safe: state.selectedPage]?.items
            else {
                updateCells(with: state.selectedPage)
                return
            }
            
            updateCellsTask?.cancel()
            filterCellsTask?.cancel()
            filterCellsTask = Task {
                var cells: [View.ListCell.Attribute] = []
                let filteredItems: [ContentItem] = items.filter {
                    $0.title.localizedCaseInsensitiveContains(text)
                    || $0.subtitle.localizedCaseInsensitiveContains(text)
                }
                for item in filteredItems {
                    guard !Task.isCancelled else { return }
                    cells.append(await getCellAttribute(item: item))
                }
                
                guard !Task.isCancelled else { return }
                
                updateState {
                    $0.cells = cells
                    $0.searchText = text
                }
            }
        }
        
        private func prepareStatistic() {
            let context: StatisticPage.Context = .init(sections: sections, selectedPage: state.selectedPage)
            
            updateState {
                $0.shouldShowStatistic = true
                $0.context = context
            }
        }
        
        private func updateState(_ update: @escaping (inout State) -> Void) {
            stateUpdateQueue.async { [weak self] in
                guard let self else { return }
                var newState = self.state
                update(&newState)
                self.state = newState
            }
        }
    }
}
