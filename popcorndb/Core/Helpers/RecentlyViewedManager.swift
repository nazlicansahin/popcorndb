//
//  RecentlyViewedManager.swift
//  popcorndb
//
//  Created by Assistant on 2025-08-13.
//

import Foundation

final class RecentlyViewedManager {
    static let shared = RecentlyViewedManager()
    private init() {}

    private let storageKey = "recently_viewed_movies"
    private let maxItems = 10

    func add(movie: Movie) {
        let item = RecentlyViewedItem(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage
        )
        add(item: item)
    }

    func add(item: RecentlyViewedItem) {
        var list = fetch()
        list.removeAll { $0.id == item.id }
        list.insert(item, at: 0)
        if list.count > maxItems { list = Array(list.prefix(maxItems)) }
        save(list)
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }

    func fetch() -> [RecentlyViewedItem] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        do {
            return try JSONDecoder().decode([RecentlyViewedItem].self, from: data)
        } catch {
            return []
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        NotificationCenter.default.post(name: .recentlyViewedUpdated, object: nil)
    }

    private func save(_ list: [RecentlyViewedItem]) {
        guard let data = try? JSONEncoder().encode(list) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
