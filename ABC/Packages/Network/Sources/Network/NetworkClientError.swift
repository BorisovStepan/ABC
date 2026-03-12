//
//  NetworkClientError.swift
//  Network
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public enum NetworkClientError: Error, LocalizedError, Equatable {
    case resourceNotFound(String)
    case failedToLoadData
    case decodingFailed

    public var errorDescription: String? {
        switch self {
        case .resourceNotFound(let name): return "Resource not found: \(name)"
        case .failedToLoadData: return "Failed to load data from bundle."
        case .decodingFailed: return "Failed to decode JSON."
        }
    }
}
