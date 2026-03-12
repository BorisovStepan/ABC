//
//  HeaderImageCell.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import DesignSystem

final class HeaderImageCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.Size.xxl.height
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    // MARK: - Private
    
    private func setupView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.Space.l),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Grid.Space.l),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.Space.l),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .zero),
        ])
    }
    
    // MARK: - Public
    
    func configure(image: Data) {
        imageView.image = UIImage(data: image)
    }
}
