//
//  TMDBAPI.swift
//  popcorndb
//
//  Created by Nazlı on 26.07.2025.
//
import Moya
import Foundation

// MARK: - Request Parameter Models

struct SearchParameters {
    let query: String
    let page: Int
    let includeAdult: Bool
    let language: Language
}

// MARK: - Endpoint Enum

enum TMDBAPI {
    case popularMovies(page: Int)
    case searchMovies(SearchParameters)
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case movieRecommendations(id: Int)
    case personDetail(id: Int)
    case nowPlaying(page: Int)
    case topRated(page: Int) //page id
    case upcoming(page: Int)
}

// MARK: - TargetType Implementation

extension TMDBAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .nowPlaying:
            return "/movie/now_playing"
        case .topRated:
            return "/movie/top_rated"
        case .upcoming:
            return "/movie/upcoming"
        case .searchMovies:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieRecommendations(let id):
            return "/movie/\(id)/recommendations"
        case .personDetail(let id):
            return "/person/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .popularMovies(let page):
            return .requestParameters(parameters: [
                "page": page,
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .nowPlaying(let page):
            return .requestParameters(parameters: [
                "page": page,
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .topRated(let page):
            return .requestParameters(parameters: [
                "page": page,
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .upcoming(let page):
            return .requestParameters(parameters: [
                "page": page,
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .movieDetail(let id):
            return .requestParameters(parameters: [
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .movieCredits(let id):
            return .requestParameters(parameters: [
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .movieRecommendations(let id):
            return .requestParameters(parameters: [
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .personDetail(let id):
            return .requestParameters(parameters: [
                "language": Language.current.rawValue
            ], encoding: URLEncoding.default)

        case .searchMovies(let params):
            let parameters: [String: Any] = [
                "query": params.query,
                "page": params.page,
                "include_adult": params.includeAdult,
                "language": Language.current.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(APIConstants.accessToken)",
            "Content-Type": "application/json"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
