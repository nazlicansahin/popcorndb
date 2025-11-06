//
//  Language.swift
//  popcorndb
//
//  Created by Nazlı on 27.07.2025.
//

import Foundation

enum Language: String {
    case english = "en-US"
    case turkish = "tr-TR"
    
    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .turkish: return "tr"
        }
    }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .turkish: return "Türkçe"
        }
    }
    
    static var current: Language {
        let code = Locale.current.languageCode ?? "en"
        switch code {
        case "tr": return .turkish
        default: return .english
        }
    }
}
extension Language {
    static var appDefault: Language { .english }
}
