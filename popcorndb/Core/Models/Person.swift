//
//  Person.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//
import Foundation

struct Person: Codable {
    let id: Int
    let name: String
    let biography: String
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let profilePath: String?
    let knownForDepartment: String
    let popularity: Double
    let imdbID: String?
    let homepage: String?
    let alsoKnownAs: [String]
    let gender: Int
    let adult: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case deathday
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
        case popularity
        case imdbID = "imdb_id"
        case homepage
        case alsoKnownAs = "also_known_as"
        case gender
        case adult
    }

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var imdbURL: URL? {
        guard let id = imdbID else { return nil }
        return URL(string: "https://www.imdb.com/name/\(id)/")
    }
}
extension Person {
    var genderDescription: String {
        switch gender {
        case 1: return "gender_female".localized
        case 2: return "gender_male".localized
        default: return "gender_other".localized
        }
    }
    
    var formattedBirthday: String? {
        guard let birthday = birthday else { return nil }
        return birthday.formattedDate
    }
    
    var formattedDeathday: String? {
        guard let deathday = deathday else { return nil }
        return deathday.formattedDate
    }
}
