//
//  HeaderView.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import DesignSystem
import Extensions

extension MainPage.View {
    
    final class HeaderView: UIView {
        
        private enum Constants {
            static let cellIndetifier: String = "HeaderImageCell"
            static let collectionHeight: CGFloat = 220
        }
        
        // MARK: - Properties
        
        private var images: [Data] = []
        var pageHasUpdated: ((Int) -> Void)?
        
        // MARK: - Views
        
        private lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = .zero
            layout.minimumInteritemSpacing = .zero
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.isPagingEnabled = true
            collection.showsHorizontalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.backgroundColor = .clear
            collection.register(HeaderImageCell.self, forCellWithReuseIdentifier: Constants.cellIndetifier)
            return collection
        }()
        
        private lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            pageControl.currentPageIndicatorTintColor = .systemBlue
            pageControl.pageIndicatorTintColor = .systemGray
            pageControl.isUserInteractionEnabled = false
            return pageControl
        }()
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Public
        
        func configure(with images: [Data]) {
            self.images = images
            pageControl.numberOfPages = images.count
            pageControl.currentPage = .zero
            collectionView.reloadData()
        }
        
        func updatePage(_ page: Int) {
            pageControl.currentPage = page
        }
        
        // MARK: - Private
        
        private func setupView() {
            backgroundColor = .clear
            
            addSubview(collectionView)
            addSubview(pageControl)
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionHeight),
                
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
}

// MARK: - Collection Protocols

extension MainPage.View.HeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIndetifier,for: indexPath) as? HeaderImageCell,
            let image = images[safe: indexPath.item]
        else { return UICollectionViewCell() }
        
        cell.configure(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rawPage = scrollView.contentOffset.x / scrollView.bounds.width
        let page = max(.zero, min(pageControl.numberOfPages - 1, Int(round(rawPage))))
        pageHasUpdated?(page)
    }
}

