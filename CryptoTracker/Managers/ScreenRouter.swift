//
//  WindowManager.swift
//  CryptoTracker
//
//  Created by Вадим on 11.11.22.
//

import UIKit


final class ScreenRouter {
    
    static let shared = ScreenRouter()
    
    lazy var window = UIWindow(frame: UIScreen.main.bounds)
    
    func showLoginScreen() {
        window.rootViewController = LoginViewController()
        window.makeKeyAndVisible()
    }
    
    func showCryptoTrackerScreen() {
        window.rootViewController = UINavigationController(rootViewController: Builder.build())
        window.makeKeyAndVisible()
    }
}
