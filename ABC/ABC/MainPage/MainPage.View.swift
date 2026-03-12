//
//  MainPage.View.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import Combine
import Extensions
import DesignSystem

extension MainPage {
    
    public final class View: UIViewController {
        
        private enum Constants {
            static let headerImageHeight: CGFloat = 248
            static let placeholder: String = "Search"
            static let cellIndentifier: String = "ListCell"
            static let buttonImage: String = "ellipsis"
            static let tableSectionsCount: Int = 1
            static let tableHeaderHeight: CGFloat = 56
            static let buttonShadowOpacity: Float = 0.3
            static let errorTitle: String = "Error"
            static let submitButton: String = "Ok"
        }
        
        // MARK: - Properties
        
        private let viewModel: ViewModel
        private var cancellables = Set<AnyCancellable>()
        private var previousState: MainPage.State?
        private var tableAttribute: [ListCell.Attribute] = []
        
        // MARK: - Views
        
        private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableHeaderView = headerView
            tableView.register(MainPage.View.ListCell.self, forCellReuseIdentifier: Constants.cellIndentifier)
            tableView.backgroundColor = .clear
            tableView.keyboardDismissMode = .onDrag
            return tableView
        }()
        
        private lazy var searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.searchBarStyle = .minimal
            searchBar.placeholder = Constants.placeholder
            searchBar.delegate = self
            searchBar.backgroundColor = .systemBackground
            return searchBar
        }()
        
        private lazy var headerView: HeaderView = {
            let header = HeaderView(
                frame: CGRect(
                    origin: .zero,
                    size: .init(width: view.bounds.width, height: Constants.headerImageHeight)
                )
            )
            header.pageHasUpdated = { [weak self] page in
                self?.viewModel.dispatch(.didSelectPage(page))
            }
            return header
        }()
        
        private lazy var statisticButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = Grid.Size.xxl.height
            button.setImage(UIImage(systemName: Constants.buttonImage), for: .normal)
            button.transform = CGAffineTransform(rotationAngle: .pi.half)
            button.imageView?.tintColor = .white
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = Constants.buttonShadowOpacity
            button.layer.shadowOffset = CGSize(width: .zero, height: Grid.Size.xxs.height)
            button.layer.shadowRadius = Grid.Size.xs.height
            button.addTarget(self, action: #selector(didTapStatistic), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Init
        
        public init(viewModel: ViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Lifecycle
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            bindViewModel()
            viewModel.dispatch(.viewDidLoad)
            setupView()
        }
        
        // MARK: - Private
        
        private func setupView() {
            view.addSubview(tableView)
            view.addSubview(statisticButton)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                statisticButton.widthAnchor.constraint(equalToConstant: Grid.Size.xxxl.width),
                statisticButton.heightAnchor.constraint(equalToConstant:  Grid.Size.xxxl.height),
                statisticButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Grid.Space.xl),
                statisticButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Grid.Space.xl)
            ])
        }
        
        private func showAlert(_ title: String) {
            let alert = UIAlertController(
                title: Constants.errorTitle,
                message: title,
                preferredStyle: .alert
            )
            
            alert.addAction(
                .init(title: Constants.submitButton, style: .default) { [weak self] _ in
                    self?.viewModel.dispatch(.dismissError)
                }
            )
            
            present(alert, animated: true)
        }
        
        @objc private func didTapStatistic() {
            viewModel.dispatch(.showStatistic)
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
        
        private func update(current: MainPage.State, previous: MainPage.State?) {
            if current.headerImages != previous?.headerImages {
                headerView.configure(with: current.headerImages)
            }
            if current.selectedPage != previous?.selectedPage {
                headerView.updatePage(current.selectedPage)
            }
            if current.cells != previous?.cells {
                tableAttribute = current.cells
                tableView.reloadData()
            }
            if current.searchText != previous?.searchText {
                searchBar.text = current.searchText
            }
            if let context = current.context, current.shouldShowStatistic {
                let vm: StatisticPage.ViewModel = .init(context: context)
                let vc: StatisticPage.View = .init(viewModel: vm)
                vc.modalPresentationStyle = .pageSheet
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.largestUndimmedDetentIdentifier = .large
                    sheet.preferredCornerRadius = Grid.Size.l.height
                }
                vc.presentationController?.delegate = self
                navigationController?.present(vc, animated: true)
            }
            if current.error != previous?.error {
                if !current.error.isEmpty {
                    showAlert(current.error)
                }
            }
        }
    }
}

// MARK: - TableView Protocols

extension MainPage.View: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        Constants.tableSectionsCount
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.tableHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableAttribute.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIndentifier, for: indexPath) as? MainPage.View.ListCell,
            let attribute = tableAttribute[safe: indexPath.row]
        else { return UITableViewCell() }
        
        cell.configure(attribute: attribute)
        return cell
    }
}

// MARK: - Search Protocol

extension MainPage.View: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.dispatch(.didChangeSearchText(searchText))
    }
}

// MARK: - Presentation Protocol

extension MainPage.View: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.dispatch(.dismiss)
    }
}

