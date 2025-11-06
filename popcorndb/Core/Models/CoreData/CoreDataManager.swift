import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate erişilemedi.")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Save
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // print("❌ Core Data save error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Add Favorite
    func addToFavorites(movie: Movie) {
        let favorite = FavoriteMovieEntity(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.releaseDate = movie.releaseDate
        favorite.voteAverage = movie.voteAverage
        favorite.posterPath = movie.posterPath

        saveContext()
    }

    // MARK: - Remove Favorite
    func removeFromFavorites(movieID: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            // print("❌ Favori silme hatası: \(error.localizedDescription)")
        }
    }

    // MARK: - Check Favorite
    func isFavorite(movieID: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            // print("❌ Favori kontrol hatası: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Fetch All
    func fetchFavorites() -> [FavoriteMovieEntity] {
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            // print("❌ Favori çekme hatası: \(error.localizedDescription)")
            return []
        }
    }
}
