//
//  ProductionCompany.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//

import Foundation

struct ProductionCompany: Codable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
