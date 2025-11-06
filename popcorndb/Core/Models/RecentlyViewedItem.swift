//
//  RecentlyViewedItem.swift
//  popcorndb
//
//  Created by Assistant on 2025-08-13.
//

import Foundation

struct RecentlyViewedItem: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

// MARK: - Movie Conversion
extension RecentlyViewedItem {
    func toMovie() -> Movie {
        return Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage
        )
    }
}

