//
//  AppDelegate.swift
//  ABC
//
//  Created by s.barysau on 12.03.26.
//

import UIKit
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let networkClient: NetworkClientProtocol = NetworkClient()
        let viewModel = MainPage.ViewModel(networkClient: networkClient)
        let mainVC = MainPage.View(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
