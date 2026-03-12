//
//  AppImage.swift
//  DesignSystem
//
//  Created by s.barysau on 12.03.26.
//

import SwiftUI

public enum AppImageSource: Equatable {
    case asset(String)
    case remote(URL)
}

public struct AppImage: View {
    public enum ImageLayoutType: Equatable {
        case fixed(CGSize)
        case flexible(height: CGFloat)
    }
    
    public struct Attribute: Equatable {
        let source: AppImageSource
        let imageLayoutType: ImageLayoutType
        let radius: CGFloat
        
        public init(source: AppImageSource, imageLayoutType: ImageLayoutType, radius: CGFloat) {
            self.source = source
            self.imageLayoutType = imageLayoutType
            self.radius = radius
        }
    }
    
    private let attribute: Attribute
    
    public init(attribute: Attribute) {
        self.attribute = attribute
    }
    
    @ViewBuilder
    public var body: some View {
        switch attribute.source {
        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFill()
                .applyLayout(attribute.imageLayoutType)
                .clipShape(RoundedRectangle(cornerRadius: attribute.radius, style: .continuous))
            
        case .remote(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .applyLayout(attribute.imageLayoutType)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .applyLayout(attribute.imageLayoutType)
                        .clipShape(RoundedRectangle(cornerRadius: attribute.radius, style: .continuous))
                    
                case .failure:
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.red)
                        .applyLayout(attribute.imageLayoutType)
                        .clipShape(RoundedRectangle(cornerRadius: attribute.radius, style: .continuous))
                    
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func applyLayout(_ layout: AppImage.ImageLayoutType) -> some View {
        switch layout {
        case let .fixed(size):
            self
                .frame(width: size.width, height: size.height)
                .clipped()
            
        case let .flexible(height):
            self
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
        }
    }
}
