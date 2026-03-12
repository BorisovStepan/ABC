//
//  MainPage.Model.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Foundation
import DesignSystem

extension MainPage {
    
    struct HeaderImage: Identifiable, Equatable {
        let image: AppImageSource
        let id: String = UUID().uuidString
    }
    
    struct State: Equatable {
        var headerImages: [HeaderImage] = []
        var selectedPage: Int = .zero
        var searchText: String = .init()
        var cells: [CellView.Attribute] = []
        var shouldShowStatistic: Bool = false
        var error: String = .init()
        var context: StatisticPage.Context?
        static let initial = Self.init()
    }

    enum Action: Equatable {
        case onAppear
        case didSelectPage(Int)
        case didChangeSearchText(String)
        case showStatistic
        case dismissError
    }
}

