//
//  SpokenLanguage.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//

struct SpokenLanguage: Codable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
