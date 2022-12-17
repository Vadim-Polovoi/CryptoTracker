//
//  MVVMBuilder.swift
//  CryptoTracker
//
//  Created by Вадим on 3.12.22.
//

import Foundation
import UIKit


final class Builder {
    static func build() -> UIViewController {
        let cryptoViewModel = CryptoViewModel()
        let cryptoTrackerViewController = CryptoTrackerViewController(viewModel: cryptoViewModel)
        return cryptoTrackerViewController
    }
}
