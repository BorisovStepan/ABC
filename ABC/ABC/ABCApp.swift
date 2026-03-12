//
//  ABCApp.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import Network
import SwiftUI

@main
struct ABCApp: App {
    private let networkClient: NetworkClientProtocol = NetworkClient()
    
    var body: some Scene {
        WindowGroup {
            MainPage.View(viewModel: MainPage.ViewModel(networkClient: networkClient))
        }
    }
}
