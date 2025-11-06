//
//  ProductionCountry.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//

struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
