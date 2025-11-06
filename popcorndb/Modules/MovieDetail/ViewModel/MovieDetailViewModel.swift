//
//  MovieDetailViewModel.swift
//  popcorndb
//
//  Created by Nazlı on 5.08.2025.
//

import Foundation

final class MovieDetailViewModel {
    
    var movieDetail: MovieDetail?
    var cast: [Cast] = []
    var recommendations: [Movie] = []
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        NetworkManager.shared.request(.movieDetail(id: id), type: MovieDetail.self) { result in
            switch result {
            case .success(let detail):
                self.movieDetail = detail
                completion(.success(detail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchCast(id: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void) {
        NetworkManager.shared.request(.movieCredits(id: id), type: CastResponse.self) { result in
            switch result {
            case .success(let response):
                self.cast = response.cast
                completion(.success(response.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchRecommendations(id: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        NetworkManager.shared.request(.movieRecommendations(id: id), type: MovieResponse<Movie>.self) { result in
            switch result {
            case .success(let response):
                self.recommendations = response.results
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
