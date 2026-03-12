//
//  StatisticPage.Model.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Network
import Foundation

extension StatisticPage {
    
    struct Context: Equatable {
        let sections: [ContentSection]
        let selectedPage: Int
        
        init(sections: [ContentSection], selectedPage: Int) {
            self.sections = sections
            self.selectedPage = selectedPage
        }
    }
    
    struct StatRow: Identifiable, Equatable {
        let id: String = UUID().uuidString
        let title: String
        let subtitle: Int
    }
    
    struct State {
        var pageStatistic: [StatRow] = []
        var topCharacters: [StatRow] = []
        static let initial: State = .init()
    }
    
    enum Action: Equatable {
        case prepareData
    }
}
