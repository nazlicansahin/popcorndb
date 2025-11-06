//
//  MovieCategoryTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 29.07.2025.
//

import UIKit
import Foundation

protocol MovieCategoryTableViewCellDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

class MovieCategoryTableViewCell: UITableViewCell {

    weak var delegate: MovieCategoryTableViewCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()

        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell") 
        
        collectionView.dataSource = self
        collectionView.delegate = self
        

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoriteStatusChanged(_:)),
            name: .favoriteStatusChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesUpdated),
            name: .favoritesUpdated,
            object: nil
        )
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .favoriteStatusChanged, object: nil)
    }
    var movies: [Movie] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
                collectionView.layoutIfNeeded() // bakın burası çok önemli

            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with movies: [Movie]) {
        self.movies = movies
    }

}

extension MovieCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        delegate?.didSelectMovie(selectedMovie)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }

        let movie = movies[indexPath.item]
        cell.configure(with: movie)

        // print("Rendering movie cell: \(movie.title)")

        cell.movieTitleLabel.text = movie.title
        cell.releaseDateLabel.text = movie.releaseDate.formattedDate
        cell.ratingLabel.text = movie.voteAverage.formattedRating
        cell.movieTitleLabel.textColor = .label
        cell.movieTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 210, height: 350)
        
    }
    @objc private func handleFavoriteStatusChanged(_ notification: Notification) {
        guard let changedID = notification.object as? Int else {
            collectionView.reloadData()
            return
        }

        // ilgili hücre efenm
        for (index, movie) in movies.enumerated() {
            if movie.id == changedID {
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.reloadItems(at: [indexPath])
                break
            }
        }
    }
    @objc private func handleFavoritesUpdated(_ notification: Notification) {
        // Tüm favori durumları değişmiş olabilir, o yüzden tamamını yenile
        collectionView.reloadData()
        
    }
    


}
