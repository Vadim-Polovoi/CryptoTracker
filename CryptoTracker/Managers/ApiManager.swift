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
    
    enum CryptoSymbols: String, CaseIterable {
        case btc
        case eth
        case trx
        case dot
        case doge
        case usdt
        case xlm
        case ada
        case xrp
    }
    
    private func makeUrl(method: String) -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.path = baseUrl + method + "/metrics"
        return component.url
    }
    
    public func getCryptoData(cryptoSymbol: String, completion: @escaping (Result<(String, Crypto), Error>) -> Void) {
        guard let cryptoUrl = makeUrl(method: cryptoSymbol) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.wrongUrl))
            }
            return
        }
        var request = URLRequest(url: cryptoUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(NetworkError.wrongStatusCode))
                    return
                }
                if let data = data,
                   let dataString = String(data: data, encoding: .utf8),
                   let cryptoResponse = try? JSONDecoder().decode(Crypto.self, from: data) {
                    completion(.success((dataString, cryptoResponse)))
                } else {
                    completion(.failure(NetworkError.wrongData))
                }
            }
        }
        task.resume()
    }
    
    public func getCryptoIcon(cryptoSymbol: String, completion: @escaping (Data) -> Void) {
        guard let cryptoIconUrl = URL(string: "https://cryptoicons.org/api/icon/\(cryptoSymbol)/128") else { return }
        let task = URLSession.shared.dataTask(with: cryptoIconUrl) { data, _, _ in
            guard let data = data else { return }
                completion(data)
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




