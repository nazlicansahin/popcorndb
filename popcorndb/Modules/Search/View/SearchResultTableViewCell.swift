import UIKit

protocol SearchResultCellDelegate: AnyObject {
    func searchResultCellDidToggleFavorite(_ cell: SearchResultTableViewCell, movie: Movie, isNewFavorite: Bool)
}

final class SearchResultTableViewCell: UITableViewCell {
    static let reuseID = "SearchResultTableViewCell"

    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: SearchResultCellDelegate?
    private var movie: Movie!
    private var isFavorite: Bool = false

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ratingLabel.text = nil
        favoriteButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie, genreMap: [Int: String]) {
        self.movie = movie
        
        // Title
        titleLabel.text = movie.title
        
        // Subtitle: Year + Genres
        let year = movie.releaseDate.yearOnly
        let genres = movie.genreIDs.compactMap { genreMap[$0] }.prefix(2).joined(separator: ", ")
        let subtitle = genres.isEmpty ? "\(year)" : "\(year) · \(genres)"
        subtitleLabel.text = subtitle
        
        // Rating
        ratingLabel.text = movie.voteAverage.formattedRating
        
        // Poster Image
        if let posterURL = movie.posterURL {
            ImageLoader.shared.setImage(on: posterImageView, url: posterURL, placeholder: UIImage(systemName: "film"))
        } else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.backgroundColor = .systemGray5
        }
        
        // Favorite state
        isFavorite = CoreDataManager.shared.isFavorite(movieID: movie.id)
        updateFavoriteIcon(isFavorite)
    }
    
    // MARK: - Actions
    @IBAction func favoriteTapped(_ sender: UIButton) {
        let newFavoriteState = !isFavorite
        
        if newFavoriteState {
            CoreDataManager.shared.addToFavorites(movie: movie)
        } else {
            CoreDataManager.shared.removeFromFavorites(movieID: movie.id)
        }
        
        isFavorite = newFavoriteState
        updateFavoriteIcon(newFavoriteState)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        delegate?.searchResultCellDidToggleFavorite(self, movie: movie, isNewFavorite: newFavoriteState)
    }

    // MARK: - Private Methods
    private func updateFavoriteIcon(_ isFav: Bool) {
        let imageName = isFav ? "heart.fill" : "heart"
        let tintColor: UIColor = isFav ? .systemRed : .systemGray3
        
        UIView.animate(withDuration: 0.2) {
            self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
            self.favoriteButton.tintColor = tintColor
        }
    }
}
