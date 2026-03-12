//
//  StatisticPage.View.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import Combine
import Extensions
import DesignSystem

extension StatisticPage {
    
    final class View: UIViewController {
        
        private enum Constants {
            static let pageTitle: String = "Pages:"
            static let charactersTitle: String = "Top Characters:"
        }
        
        // MARK: - Properties
        
        private let viewModel: ViewModel
        private var cancellables = Set<AnyCancellable>()
        private var previousState: StatisticPage.State?
        
        // MARK: - Views
        
        private lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
        
        private lazy var contentStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = Grid.Space.l
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        // MARK: - Init
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            bindViewModel()
            viewModel.dispatch(.viewDidLoad)
            setupView()
        }
        
        // MARK: - Private
        
        private func setupView() {
            view.addSubview(scrollView)
            scrollView.addSubview(contentStack)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Grid.Space.l),
                contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: Grid.Space.l),
                contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -Grid.Space.l),
                contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Grid.Space.l),
            ])
        }
        
        private func update(current: StatisticPage.State, previous: StatisticPage.State?) {
            if current.pageStatistic != previous?.pageStatistic {
                let pagesSection = StatsSectionBuilder.makeSection(
                    title: Constants.pageTitle,
                    rows: current.pageStatistic
                )
                contentStack.arrangedSubviews.forEach {
                    contentStack.removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
                contentStack.addArrangedSubview(pagesSection)
            }
            
            if current.topCharacters != previous?.topCharacters {
                let topCharacters = StatsSectionBuilder.makeSection(
                    title: Constants.charactersTitle,
                    rows: current.topCharacters
                )
                contentStack.addArrangedSubview(topCharacters)
            }
        }
        
        // MARK: - Bind
        
        private func bindViewModel() {
            viewModel.$state
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newState in
                    self?.update(current: newState, previous: self?.previousState)
                    self?.previousState = newState
                }
                .store(in: &cancellables)
        }
    }
}
