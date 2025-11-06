//
//  MovieSection.swift
//  popcorndb
//
//  Created by Nazlı on 30.07.2025.
//

import Foundation

struct MovieSection {
    let title: String
    let endpoint: TMDBAPI
}

extension MovieSection {
    static func allSections() -> [MovieSection] {
        [
            MovieSection(title: "movielist_section_popular".localized, endpoint: .popularMovies(page: 1)),
            MovieSection(title: "movielist_section_top_rated".localized, endpoint: .topRated(page: 1)),
            MovieSection(title: "movielist_section_upcoming".localized, endpoint: .upcoming(page: 1)),
            MovieSection(title: "movielist_section_now_playing".localized, endpoint: .nowPlaying(page: 1))
        ]
    }
}
