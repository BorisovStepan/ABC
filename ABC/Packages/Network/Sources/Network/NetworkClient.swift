//
//  NetworkClient.swift
//  Network
//
//  Created by s.barysau on 12.03.26.
//

import Foundation

public final class NetworkClient: NetworkClientProtocol {
    
    public init() {}
    
    public func fetchData() async throws -> [ContentSection] {
        guard let url = Bundle.main.url(forResource: "mock_data", withExtension: "json") else {
            throw NetworkClientError.resourceNotFound("mock_data.json")
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        do {
            return try decoder.decode([ContentSection].self, from: data)
        } catch {
            throw NetworkClientError.decodingFailed
        }
    }
    
    public func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
