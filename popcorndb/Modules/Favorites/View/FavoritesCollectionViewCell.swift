//
//  FavoritesCollectionViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 2.08.2025.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    private var currentMovieID: Int?
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    weak var delegate: FavoritesCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentMovieID = nil
        movieTitleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
        movieImageView.image = nil
        favoriteButton.isHidden = false
        favoriteButton.isEnabled = true
    }

    // MARK: - Configure: Favorite entity
    func configure(with movie: FavoriteMovieEntity) {
        favoriteButton.isHidden = false
        favoriteButton.isEnabled = true
        currentMovieID = Int(movie.id)
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)

        if let posterPath = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)" //helper kullan
            if let url = URL(string: urlString) {
                loadImage(from: url)
            }
        }
    }

    // MARK: - Configure: Recently viewed (light model)
    func configure(with item: RecentlyViewedItem) {
        // No favorite action here
        favoriteButton.isHidden = true
        favoriteButton.isEnabled = false
        currentMovieID = nil
        movieTitleLabel.text = item.title
        releaseDateLabel.text = item.releaseDate.formattedDate
        ratingLabel.text = item.voteAverage.formattedRating
        if let url = item.posterURL {
            loadImage(from: url)
        }
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
        guard let id = currentMovieID else { return }
        CoreDataManager.shared.removeFromFavorites(movieID: id)
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        delegate?.didTapFavoriteButton(in: self)
    }
}

