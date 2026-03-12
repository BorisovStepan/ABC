//
//  StatsSectionBuilder.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import DesignSystem

extension StatisticPage.View {
    
    struct StatsSectionBuilder {
        
        static func makeSection(title: String, rows: [StatisticPage.StatRow]) -> UIStackView {
            let sectionStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .vertical
                stack.spacing = Grid.Space.m
                stack.alignment = .leading
                stack.translatesAutoresizingMaskIntoConstraints = false
                return stack
            }()
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.text = title
                label.font = .preferredFont(forTextStyle: .headline)
                label.numberOfLines = .zero
                return label
            }()
            
            sectionStack.addArrangedSubview(titleLabel)
            
            for row in rows {
                sectionStack.addArrangedSubview(makeRow(title: row.title, subtitle: String(row.subtitle)))
            }
            
            return sectionStack
        }
        
        private static func makeRow(title: String, subtitle: String) -> UIStackView {
            let statisticStack: UIStackView = {
                let stack = UIStackView()
                stack.spacing = Grid.Space.m
                return stack
            }()
            
            let title: UILabel = {
                let label = UILabel()
                label.text = title
                label.font = .preferredFont(forTextStyle: .body)
                return label
            }()
            
            let subtitle: UILabel = {
                let label = UILabel()
                label.text = subtitle
                label.font = .preferredFont(forTextStyle: .body)
                return label
            }()
            
            statisticStack.addArrangedSubview(title)
            statisticStack.addArrangedSubview(subtitle)
            
            return statisticStack
        }
    }
}

