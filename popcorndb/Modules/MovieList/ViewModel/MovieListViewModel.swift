//
//  MovieListViewModel.swift
//  popcorndb
//
//  Created by Nazlı on 29.07.2025.
//

import Foundation
import Moya

final class MovieListViewModel {
    
    private let provider = MoyaProvider<TMDBAPI>()
    
    let sections: [MovieSection] = [
        MovieSection(title: "movielist_section_popular".localized, endpoint: .popularMovies(page: 1)),
        MovieSection(title: "movielist_section_top_rated".localized, endpoint: .topRated(page: 1)),
        MovieSection(title: "movielist_section_now_playing".localized, endpoint: .nowPlaying(page: 1)),
        MovieSection(title: "movielist_section_upcoming".localized, endpoint: .upcoming(page: 1))
    ]
    
    func fetchMovies(for section: MovieSection, completion: @escaping ([Movie]) -> Void) {
        provider.request(section.endpoint) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(MovieResponse<Movie>.self, from: response.data)
                    completion(decoded.results)
                } catch {
                    print("❌ Decode Error: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("❌ Network Error: \(error)")
                completion([])
            }
        }
    }
}
