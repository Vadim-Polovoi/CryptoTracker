//
//  CryptoTableViewModel.swift
//  CryptoTracker
//
//  Created by Вадим on 1.11.22.
//

import Foundation


protocol MVVMProtocolIn {
    var cryptos: [CryptoModel] { get set }
    
    func getAllCryptoData()
    
    func sortCryptos()
}

protocol MVVMProtocolOut {
    var reloadTableView: () -> Void { get set }
    
    var showError: (Error) -> Void { get set }
}

final class CryptoViewModel: MVVMProtocolIn, MVVMProtocolOut {
    
    var cryptos = [CryptoModel]()
    
    var errors = [Error]()
    
    var reloadTableView: () -> Void = {}
    
    var showError: (Error) -> Void = { _ in }
    
    var sortOrder = SortOrder.descending
    
    func getAllCryptoData() {
        let asyncGroup = DispatchGroup()
        for cryptoName in ApiManager.CryptoNames.allCases {
            asyncGroup.enter()
            ApiManager.shared.getCryptoData(cryptoName: cryptoName.rawValue) { [weak self] result in
                switch result {
                case .success(let (_, crypto)):
                    self?.cryptos.append(CryptoModel(crypto: crypto))
                case .failure(let error):
                    self?.errors.append(error)
                }
                asyncGroup.leave()
            }
        }
        asyncGroup.notify(queue: .main) { [weak self] in
            self?.sortCryptos()
            self?.reloadTableView()
            if let error = self?.errors.first {
                self?.showError(error)
            }
        }
    }
    
    func sortCryptos() {
        switch sortOrder {
        case .ascending:
            cryptos.sort { $0.priceUsd < $1.priceUsd }
            sortOrder = SortOrder.descending
        case .descending:
            cryptos.sort { $0.priceUsd > $1.priceUsd }
            sortOrder = SortOrder.ascending
        }
    }
}
