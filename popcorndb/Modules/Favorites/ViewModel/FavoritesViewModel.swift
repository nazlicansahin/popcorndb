//
//  FavoritesViewModel.swift
//  popcorndb
//
//  Created by Nazlı on 4.08.2025.
//

import Foundation

final class FavoritesViewModel {

    enum FavoritesSection: Int, CaseIterable {
        case recentlyViewed
        case favorites

        var localizedTitle: String {
            switch self {
            case .recentlyViewed:
                return NSLocalizedString("favorites_recently_viewed", comment: "")
            case .favorites:
                return NSLocalizedString("favorites_favorites", comment: "")
            }
        }
    }

    var sections: [FavoritesSection] {
        return FavoritesSection.allCases
    }

    var recentlyViewedMovies: [RecentlyViewedItem] = []
    var favoriteMovies: [FavoriteMovieEntity] = []

    init() {
        recentlyViewedMovies = RecentlyViewedManager.shared.fetch()
        NotificationCenter.default.addObserver(self, selector: #selector(recentlyViewedUpdated), name: .recentlyViewedUpdated, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .recentlyViewedUpdated, object: nil)
    }

    func movies(for section: FavoritesSection) -> [Any] {
        switch section {
        case .recentlyViewed:
            return recentlyViewedMovies
        case .favorites:
            return favoriteMovies
        }
    }

    func reloadFavorites() {
        favoriteMovies = CoreDataManager.shared.fetchFavorites()
    }

    @objc private func recentlyViewedUpdated() {
        recentlyViewedMovies = RecentlyViewedManager.shared.fetch()
    }
}
