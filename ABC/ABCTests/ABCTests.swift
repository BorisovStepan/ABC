//
//  ABCTests.swift
//  ABCTests
//
//  Created by s.barysau on 12.03.26.
//

import XCTest
@preconcurrency import Network

@testable import ABC

final class ABCTests: XCTestCase {

    func testLoadData() {
        guard let url = URL(string: "https://example.com/section.jpg") else { return }
        let section = ContentSection(
            id: "section",
            imageUrl: url,
            items: [
                .init(
                    imageUrl: url,
                    title: "Title",
                    subtitle: "Subtitle"
                )
            ]
        )
        
        let networkClient = NetworkClientMock(result: .success([section]))
        let viewModel = MainPage.ViewModel(networkClient: networkClient)
        
        viewModel.dispatch(.onAppear)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.state.headerImages.count, 1)
            XCTAssertEqual(viewModel.state.cells.count, 1)
            XCTAssertEqual(viewModel.state.selectedPage, 0)
            XCTAssertTrue(viewModel.state.error.isEmpty)
        }
    }
    
    func testFailLoadData() {
        let networkClient = NetworkClientMock(result: .failure(TestError.fetchFailed))
        let viewModel = MainPage.ViewModel(networkClient: networkClient)
        
        viewModel.dispatch(.onAppear)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.state.error, TestError.fetchFailed.localizedDescription)
            XCTAssertEqual(viewModel.state.headerImages.count, 0)
            XCTAssertEqual(viewModel.state.cells.count, 0)
        }
    }
}

// MARK: - Mock Network Client

private struct NetworkClientMock: NetworkClientProtocol {
    
    let result: Result<[ContentSection], Error>
    
    func fetchData() async throws -> [ContentSection] {
        switch result {
        case .success(let sections):
            return sections
        case .failure(let error):
            throw error
        }
    }
    
    func fetchImageData(from url: URL) async throws -> Data {
        Data()
    }
}

// MARK: - Test Error

private enum TestError: LocalizedError {
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Fetch failed"
        }
    }
}
