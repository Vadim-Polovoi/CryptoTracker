//
//  Data.swift
//  CryptoTracker
//
//  Created by Вадим on 1.11.22.
//

import Foundation


struct CryptoModel {
    let name: String
    let symbol: String
    let priceUsd: Double
    let percentChangeUsdLast24Hours: Double
    
    init(crypto: Crypto) {
        self.name = crypto.data?.name ?? "N/A"
        self.symbol = crypto.data?.symbol ?? "N/A"
        self.priceUsd = crypto.data?.marketData?.priceUsd ?? 0
        self.percentChangeUsdLast24Hours = crypto.data?.marketData?.percentChangeUsdLast24Hours ?? 0
    }
}

struct Crypto: Codable {
    let data: CryptoData?
}

struct CryptoData: Codable {
    let name: String?
    let symbol: String?
    let marketData: MarketData?

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case marketData = "market_data"
    }
}

struct MarketData: Codable {
    let priceUsd: Double?
    let percentChangeUsdLast24Hours: Double?

    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
        case percentChangeUsdLast24Hours = "percent_change_usd_last_24_hours"
    }
}
