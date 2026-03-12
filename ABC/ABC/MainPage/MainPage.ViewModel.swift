//
//  MainPage.ViewModel.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Network
import Combine
import Foundation
import Extensions
import DesignSystem

extension MainPage {
    
    public class ViewModel: ObservableObject {
        
        @Published var state: State = .initial
        private let networkClient: NetworkClientProtocol
        private var sections: [ContentSection] = []
        private var loadDataTask: Task<Void, Never>?
        
        public init(networkClient: NetworkClientProtocol) {
            self.networkClient = networkClient
        }
        
        func dispatch(_ action: Action) {
            switch action {
                
            case .onAppear:
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
                
            case .dismissError:
                updateState { $0.error = .init() }
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
            
            let cells: [CellView.Attribute] = items
                .filter { cell in
                    cell.subtitle.localizedCaseInsensitiveContains(text)
                    || cell.title.localizedCaseInsensitiveContains(text)
                }
                .map {
                    return .init(
                        title: $0.title,
                        subtitle: $0.subtitle,
                        image: .init(
                            source: .remote($0.imageUrl),
                            imageLayoutType: .fixed(Grid.Size.xxxl),
                            radius: Grid.Size.s.height
                        )
                    )
                }
            
            updateState {
                $0.cells = cells
                $0.searchText = text
            }
        }
        
        private func updateCells(with index: Int) {
            guard let items = sections[safe: index]?.items else { return }
            
            let cells: [CellView.Attribute] = items.map {
                return .init(
                    title: $0.title,
                    subtitle: $0.subtitle,
                    image: .init(
                        source: .remote($0.imageUrl),
                        imageLayoutType: .fixed(Grid.Size.xxxl),
                        radius: Grid.Size.s.height
                    )
                )
            }
            
            updateState {
                $0.cells = cells
                $0.searchText = .init()
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
                        let headerImages: [HeaderImage] = sections.map {
                            return .init(image: .remote($0.imageUrl))
                        }
                        self?.updateState { $0.headerImages = headerImages }
                    }
                } catch {
                    self?.updateState { $0.error = error.localizedDescription }
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
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                var newState = self.state
                update(&newState)
                self.state = newState
            }
        }
    }
}
