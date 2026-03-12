//
//  StatisticPage.View.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import SwiftUI
import DesignSystem

extension StatisticPage {
    
    public struct View: SwiftUI.View {
        
        private enum Constants {
            static let pageTitle: String = "Pages:"
            static let charactersTitle: String = "Top Characters:"
        }
        
        @StateObject var viewModel: ViewModel
        
        public init(viewModel: ViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
        
        public var body: some SwiftUI.View {
            ScrollView {
                VStack(alignment: .leading, spacing: Grid.Space.m) {
                    Text(Constants.pageTitle)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    ForEach(viewModel.state.pageStatistic) { item in
                        HStack(spacing: Grid.Space.m) {
                            Text(item.title)
                                .font(.body)
                                .foregroundStyle(.black)
                            
                            Text(String(item.subtitle))
                                .font(.body)
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Text(Constants.charactersTitle)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    ForEach(viewModel.state.topCharacters) { item in
                        HStack(spacing: Grid.Space.m) {
                            Text(item.title)
                                .font(.body)
                                .foregroundStyle(.black)
                            
                            Text(String(item.subtitle))
                                .font(.body)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all, Grid.Space.l)
            }
            .onAppear { viewModel.dispatch(.prepareData) }
        }
    }
}
