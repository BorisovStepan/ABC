//
//  Grid.swift
//  DesignSystem
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public enum Grid {
    
    // MARK: - Spacing
    
    public enum Space {
        public static let xxs: CGFloat = 2
        public static let xs: CGFloat = 4
        public static let s: CGFloat = 8
        public static let m: CGFloat = 12
        public static let l: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
        public static let xxxl: CGFloat = 48
    }
    
    // MARK: - Sizes
    
    public enum Size {
        public static let xxs: CGSize = .init(width: 2, height: 2)
        public static let xs: CGSize = .init(width: 4, height: 4)
        public static let s: CGSize = .init(width: 8, height: 8)
        public static let m: CGSize = .init(width: 12, height: 12)
        public static let l: CGSize = .init(width: 16, height: 16)
        public static let xl: CGSize = .init(width: 20, height: 20)
        public static let xxl: CGSize = .init(width: 24, height: 24)
        public static let xxxl: CGSize = .init(width: 48, height: 48)
    }
}
