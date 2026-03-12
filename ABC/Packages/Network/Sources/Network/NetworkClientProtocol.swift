//
//  NetworkClientProtocol.swift
//  Network
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public protocol NetworkClientProtocol: Sendable {
    func fetchData() async throws -> [ContentSection]
    func fetchImageData(from url: URL) async throws -> Data
}
