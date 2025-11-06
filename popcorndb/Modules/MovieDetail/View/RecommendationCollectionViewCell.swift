//
//  RecommendationCollectionViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 5.08.2025.
//
// RecommendationCollectionViewCell.swift
import UIKit

final class RecommendationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var releaseDateLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton!
    
    static let reuseID = "RecommendationCollectionViewCell"
    private var currentMovie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView?.image = nil
        titleLabel?.text = nil
        releaseDateLabel?.text = nil
        ratingLabel?.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .lightGray

    }
    
    func configure(with movie: Movie, isFavorite: Bool) {
        currentMovie = movie
        titleLabel?.text = movie.title
        releaseDateLabel?.text = movie.releaseDate.formattedDate
        ratingLabel?.text = movie.voteAverage.formattedRating
        
        
        if let path = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.movieImageView?.image = UIImage(data: data)
                }
            }.resume()
        }
        // favori ikonunu güncelle
        let isFav = CoreDataManager.shared.isFavorite(movieID: movie.id)
        favoriteButton.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = isFav ? .systemRed : .lightGray
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

        // Uygulama geneline haber ver (senin kullandığın isimle)
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: movie.id)
    }
}
