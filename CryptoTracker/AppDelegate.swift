//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Вадим on 31.10.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoginManager.shared.start()
        return true
    }
}

