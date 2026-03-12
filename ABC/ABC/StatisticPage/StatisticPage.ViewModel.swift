//
//  StatisticPage.ViewModel.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Network
import Foundation
import Extensions
import Combine

extension StatisticPage {
    
    final class ViewModel: ObservableObject {
        
        @Published var state: State = .initial
        let context: Context
        let stateUpdateQueue: DispatchQueue = .init(label: "StateUpdateQueue")
        
        init(context: Context) {
            self.context = context
        }
        
        func dispatch(_ action: Action) {
            switch action {
                case .viewDidLoad:
                    prepareStatistic()
            }
        }
        
        private func prepareStatistic() {
            Task { [weak self] in
                guard
                    let self,
                    let items = context.sections[safe: context.selectedPage]?.items
                else { return }
            
                let pageStatistic: [StatRow] = context.sections.enumerated().map { index, section in
                    return .init(title: "Page \(index + 1) =", subtitle: section.items.count)
                }
                
                let topCharacters: [StatRow] = topCharacters(in: items)
                    .map {
                        return .init(title: $0.key, subtitle: $0.value)
                    }
                    .sorted {
                        $0.subtitle > $1.subtitle
                    }
                
                updateState {
                    $0.pageStatistic = pageStatistic
                    $0.topCharacters = topCharacters
                }
            }
        }
        
        private func topCharacters(in items: [ContentItem]) -> [String: Int] {
            let characters = items
                .flatMap { $0.title.lowercased() }
                .filter { $0.isLetter }
            
            let counts = Dictionary(grouping: characters, by: { $0 })
                .mapValues { $0.count }
            
            let top3 = counts
                .sorted { $0.value > $1.value }
                .prefix(3)
            
            return Dictionary(
                uniqueKeysWithValues: top3.map { (String($0.key), $0.value) }
            )
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
