//
//  MainPage.Model.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

extension MainPage {

    struct State: Equatable {
        var headerImages: [Data] = []
        var cells: [View.ListCell.Attribute] = []
        var selectedPage: Int = .zero
        var searchText: String = .init()
        var shouldShowStatistic: Bool = false
        var context: StatisticPage.Context?
        var error: String = .init()
        static let initial: State = .init()
    }
    
    enum Action: Equatable {
        case viewDidLoad
        case didSelectPage(Int)
        case didChangeSearchText(String)
        case showStatistic
        case dismiss
        case dismissError
    }
}
