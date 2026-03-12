//
//  CellView.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import SwiftUI
import DesignSystem

extension MainPage {
    
    public struct CellView: SwiftUI.View {
        
        private enum Constants {
            static let backgroundOpacity: Double = 0.18
        }
        
        public struct Attribute: Identifiable, Equatable {
            let title: String
            let subtitle: String
            let image: AppImage.Attribute
            public let id: String = UUID().uuidString
        }
        
        let attribute: Attribute
        
        public var body: some SwiftUI.View {
            HStack(spacing: Grid.Space.l) {
                AppImage(attribute: attribute.image)
                
                VStack(alignment: .leading, spacing: Grid.Space.xs) {
                    Text(attribute.title)
                        .font(.headline)
                    
                    Text(attribute.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.all, Grid.Space.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Grid.Size.m.height, style: .continuous)
                    .fill(.mint.opacity(Constants.backgroundOpacity))
            )
        }
    }
}
