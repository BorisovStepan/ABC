//
//  MainPage.View.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import SwiftUI
import Extensions
import DesignSystem

extension MainPage {
    
    public struct View: SwiftUI.View {
        
        private enum Constants {
            static let headerHeight: CGFloat = 200
            static let grayOpacity: Double = 0.4
            static let animationDuration: Double = 0.2
            static let buttonImage: String = "ellipsis"
            static let errorTitle: String = "Error"
            static let submitButton: String = "Ok"
        }
        
        @StateObject var viewModel: ViewModel
        @FocusState private var isSearchFocused: Bool
        
        public init(viewModel: ViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
        
        public var body: some SwiftUI.View {
            ZStack(alignment: .bottomTrailing) {
                contentView
                statisticButton
            }
            .alert(
                Constants.errorTitle,
                isPresented: .init(
                    get: { !viewModel.state.error.isEmpty },
                    set: { _ in }
                )
            ) {
                Button(Constants.submitButton) {
                    viewModel.dispatch(.dismissError)
                }
            } message: {
                Text(viewModel.state.error)
            }
            .sheet(isPresented: $viewModel.state.shouldShowStatistic) {
                if let context = viewModel.state.context {
                    StatisticPage.View(viewModel: .init(context: context))
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
        }
        
        var contentView: some SwiftUI.View {
            ScrollView {
                LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
                    headerView
                    
                    pageIndicatorView
                        .padding(.vertical, Grid.Space.s)
                    
                    cellsSection
                }
            }
            .background(Color(.systemBackground))
            .simultaneousGesture(
                TapGesture().onEnded {
                    isSearchFocused = false
                }
            )
            .task {
                viewModel.dispatch(.onAppear)
            }
        }
        
        var headerView: some SwiftUI.View {
            TabView(
                selection: .init(
                    get: { viewModel.state.selectedPage },
                    set: { viewModel.dispatch(.didSelectPage($0)) }
                )
            ) {
                ForEach(Array(viewModel.state.headerImages.enumerated()), id: \.offset) { index, image in
                    AppImage(
                        attribute: .init(
                            source: image.image,
                            imageLayoutType: .flexible(height: Constants.headerHeight),
                            radius: Grid.Size.xl.height
                        )
                    )
                    .padding(.all, Grid.Space.xl)
                    .tag(index)
                }
            }
            .frame(height: Constants.headerHeight)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
        var pageIndicatorView: some SwiftUI.View {
            HStack(spacing: Grid.Space.s) {
                ForEach(viewModel.state.headerImages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.state.selectedPage ? .blue : .gray.opacity(Constants.grayOpacity))
                        .frame(width: Grid.Size.s.width, height: Grid.Size.s.height)
                        .animation(.easeInOut(duration: Constants.animationDuration), value: viewModel.state.selectedPage)
                }
            }
        }
        
        var cellsSection: some SwiftUI.View {
            Section(
                header: SearchField(
                    text: .init(
                        get: { viewModel.state.searchText },
                        set: { text in
                            viewModel.dispatch(.didChangeSearchText(text))
                        }
                    ),
                    focus: $isSearchFocused
                )
                .padding(.all, Grid.Space.xl)
            ) {
                ForEach(viewModel.state.cells) { cell in
                    CellView(attribute: cell)
                        .padding(.horizontal, Grid.Space.m)
                }
                .padding(.top, Grid.Space.xs)
            }
        }
        
        var statisticButton: some SwiftUI.View {
            Button(action: { viewModel.dispatch(.showStatistic) }) {
                Image(systemName: Constants.buttonImage)
                    .foregroundStyle(.white)
                    .rotationEffect(.radians(.pi.half))
                    .frame(width: Grid.Size.xxxl.width, height: Grid.Size.xxxl.height)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .shadow(radius: Grid.Size.s.height, y: Grid.Size.xs.height)
            .contentShape(Circle())
            .padding(.trailing, Grid.Space.m)
            .padding(.bottom, Grid.Space.m)
        }
    }
}
