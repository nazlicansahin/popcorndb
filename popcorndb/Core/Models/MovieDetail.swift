//
//  MovieDetail.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//
import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let budget: Int
    let revenue: Int
    let runtime: Int?
    let homepage: String?
    let imdbID: String?
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool
    let video: Bool
    let tagline: String?
    let status: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let originalLanguage: String
    let originCountry: [String]
    
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let spokenLanguages: [SpokenLanguage]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, budget, revenue, runtime, homepage
        case imdbID = "imdb_id"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case adult, video, tagline, status, popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres, productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case originCountry = "origin_country"
    }
}
extension MovieDetail {
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var imdbURL: URL? {
        guard let id = imdbID else { return nil }
        return URL(string: "https://www.imdb.com/title/\(id)/")
    }
}
