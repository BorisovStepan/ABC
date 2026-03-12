//
//  File.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import DesignSystem

extension MainPage.View {
    
    final class ListCell: UITableViewCell {
        
        private enum Constants {
            static let backgroundOpacity: Double = 0.15
        }
        
        // MARK: - Attribute
        
        struct Attribute: Equatable {
            let title: String
            let subtitle: String
            let image: Data
        }
        
        // MARK: - Views
        
        private lazy var image: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
            image.layer.cornerRadius = Grid.Size.s.height
            return image
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .headline)
            label.numberOfLines = .zero
            return label
        }()
        
        private lazy var subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabel
            label.numberOfLines = .zero
            return label
        }()
        
        private lazy var containerStack: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .center
            stack.spacing = Grid.Space.m
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: Grid.Space.m, left:  Grid.Space.m, bottom: Grid.Space.m, right: Grid.Space.m)
            stack.layer.cornerRadius = Grid.Size.m.height
            stack.backgroundColor = UIColor.systemMint.withAlphaComponent(Constants.backgroundOpacity)
            stack.addArrangedSubview(image)
            stack.addArrangedSubview(textStack)
            return stack
        }()
        
        private lazy var textStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = Grid.Space.xxs
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(subtitleLabel)
            return stack
        }()
        
        // MARK: - Init
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        public override func prepareForReuse() {
            super.prepareForReuse()
            image.image = nil
            titleLabel.text = nil
            subtitleLabel.text = nil
        }
        
        // MARK: - Private
        
        private func setupView() {
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: Grid.Size.xxxl.width),
                image.heightAnchor.constraint(equalToConstant: Grid.Size.xxxl.height)
            ])
            
            contentView.layer.masksToBounds = true
            contentView.backgroundColor = .clear
            contentView.addSubview(containerStack)
            NSLayoutConstraint.activate([
                containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.Space.xs),
                containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Grid.Space.m),
                containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.Space.m),
                containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Grid.Space.xs),
            ])
        }
        
        // MARK: - Public
        
        func configure(attribute: Attribute) {
            titleLabel.text = attribute.title
            subtitleLabel.text = attribute.subtitle
            image.image = UIImage(data: attribute.image)
        }
    }
}

