//
//  Movie.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//
import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let originalTitle: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIDs: [Int]
    let originalLanguage: String
    let adult: Bool
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case adult
        case video
    }
    init(title: String, posterPath: String?, releaseDate: String, voteAverage: Double) {
        self.id = 0
        self.title = title
        self.originalTitle = ""
        self.posterPath = posterPath
        self.backdropPath = nil
        self.overview = ""
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = 0
        self.popularity = 0
        self.genreIDs = []
        self.originalLanguage = ""
        self.adult = false
        self.video = false
    }
    init(id: Int = 0,
         title: String,
         originalTitle: String? = nil,
         posterPath: String? = nil,
         backdropPath: String? = nil,
         overview: String = "",
         releaseDate: String,
         voteAverage: Double,
         voteCount: Int = 0,
         popularity: Double = 0,
         genreIDs: [Int] = [],
         originalLanguage: String = "en",
         adult: Bool = false,
         video: Bool = false) {
        
        self.id = id
        self.originalTitle = originalTitle
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.popularity = popularity
        self.genreIDs = genreIDs
        self.originalLanguage = originalLanguage
        self.adult = adult
        self.video = video
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
}
