//
//  ApiCaller.swift
//  CryptoTracker
//
//  Created by Вадим on 1.11.22.
//

import Foundation


final class ApiManager {
    
    static let shared = ApiManager()
    
    private let baseUrl = "data.messari.io/api/v1/assets/"
    
    enum CryptoNames: String, CaseIterable {
        case btc = "btc"
        case eth = "eth"
        case tron = "tron"
        case polkadot = "polkadot"
        case dogecoin = "dogecoin"
        case tether = "tether"
        case stellar = "stellar"
        case cardano = "cardano"
        case xrp = "xrp"
    }
    
    private func makeUrl(method: String) -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.path = baseUrl + method + "/metrics"
        return component.url
    }

    public func getCryptoData(cryptoName: String, completion: @escaping (Result<(String, Crypto), Error>) -> Void) {
        guard let cryptoUrl = makeUrl(method: cryptoName) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.wrongUrl))
            }
            return
        }
        var request = URLRequest(url: cryptoUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.wrongStatusCode))
                }
                return
            }
            if let data = data,
               let dataString = String(data: data, encoding: .utf8),
               let cryptoResponse = try? JSONDecoder().decode(Crypto.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success((dataString, cryptoResponse)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.wrongData))
                }
            }
        }
        task.resume()
    }
}

enum NetworkError: Error, LocalizedError {
    case wrongStatusCode
    case wrongUrl
    case wrongData
    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return "Wrong status code"
        case .wrongUrl:
            return "Wrong URL"
        case .wrongData:
            return "Wrong data"
        }
    }
}




