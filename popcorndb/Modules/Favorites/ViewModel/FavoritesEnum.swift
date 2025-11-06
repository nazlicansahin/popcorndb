//
//  FavoritesEnum.swift
//  popcorndb
//
//  Created by Nazlı on 4.08.2025.
//
import Foundation

enum FavoritesSection: Int, CaseIterable {
    case recentlyViewed
    case favorites

    var localizedTitle: String {
        switch self {
        case .recentlyViewed: return "favorites_recently_viewed".localized
        case .favorites: return "favorites_favorites".localized
        }
    }
}
