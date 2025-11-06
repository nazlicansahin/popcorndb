//
//  NetworkManager.swift
//  popcorndb
//
//  Created by Nazlı on 26.07.2025.
//
import Moya
import Foundation

let networkLogger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))

final class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<TMDBAPI>(plugins: [networkLogger])

    private init() {}

    func request<T: Decodable>(_ target: TMDBAPI,
                               type: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decoding(error)))
                }
            case .failure(let error):
                completion(.failure(.request(error)))
            }
        }
    }
}
