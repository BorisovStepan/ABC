//
//  Extension.Collection.swift
//  Extensions
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
