//
//  MovieCollectionViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 29.07.2025.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    var currentMovie: Movie?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with movie: Movie) {
        self.currentMovie = movie
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate.formattedDate
        ratingLabel.text = movie.voteAverage.formattedRating

        if let path = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(path)"
            if let url = URL(string: urlString) {
                loadImage(from: url)
            }
        }

        let isFav = CoreDataManager.shared.isFavorite(movieID: movie.id)
        let image = UIImage(systemName: isFav ? "heart.fill" : "heart")
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFav ? .systemRed : .lightGray
    }
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let movie = currentMovie else { return }

        if CoreDataManager.shared.isFavorite(movieID: movie.id) {
            CoreDataManager.shared.removeFromFavorites(movieID: movie.id)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .lightGray
        } else {
            CoreDataManager.shared.addToFavorites(movie: movie)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        }
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: movie.id)

    }
    
    
}
