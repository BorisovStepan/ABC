//
//  ContentSection.swift
//  Network
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public struct ContentSection: Codable, Equatable {
    public let id: String
    public let imageUrl: URL
    public let items: [ContentItem]

    public init(id: String, imageUrl: URL, items: [ContentItem]) {
        self.id = id
        self.imageUrl = imageUrl
        self.items = items
    }
}

public struct ContentItem: Codable, Equatable {
    public let imageUrl: URL
    public let title: String
    public let subtitle: String

    public init(imageUrl: URL, title: String, subtitle: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
    }
}
