//
//  LogManager.swift
//  CryptoTracker
//
//  Created by Вадим on 3.12.22.
//

import Foundation


enum UserDefaultsKey: String {
    case key = "LOGGED_IN"
}

final class LoginManager {
    
    static let shared = LoginManager()
    
    private let defaults = UserDefaults.standard
    
    func start() {
        if defaults.bool(forKey: UserDefaultsKey.key.rawValue) {
            ScreenRouter.shared.showCryptoTrackerScreen()
        } else {
            ScreenRouter.shared.showLoginScreen()
        }
    }
    
    func logout() {
        defaults.set(false, forKey: UserDefaultsKey.key.rawValue)
        ScreenRouter.shared.showLoginScreen()
    }
    
    func login() {
        defaults.set(true, forKey: UserDefaultsKey.key.rawValue)
        ScreenRouter.shared.showCryptoTrackerScreen()
    }
}


