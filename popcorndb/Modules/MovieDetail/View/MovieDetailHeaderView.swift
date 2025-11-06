//
//  MovieDetailHeaderView.swift
//  popcorndb
//
//  Created by Nazlı on 5.08.2025.
//

import UIKit

// MARK: - Delegate
protocol MovieDetailHeaderViewDelegate: AnyObject {
    func movieDetailHeaderViewDidToggleFavorite(_ header: MovieDetailHeaderView, isFavorite: Bool)
}


class MovieDetailHeaderView: UIView {

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var originalTitleLabel: UILabel!
    
    @IBOutlet weak var originalTitleDataLabel: UILabel!
    
    @IBOutlet weak var originalLanguageLabel: UILabel!
    
    @IBOutlet weak var originalLanguageDataLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var releaseDateData: UILabel!
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var budgetData: UILabel!
    
    
    @IBOutlet weak var revenueLabel: UILabel!
    
    @IBOutlet weak var revenueData: UILabel!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var genresData: UILabel!
    
    @IBOutlet weak var runtimeData: UILabel!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    
    
    @IBOutlet weak var productionCompaniesLabel: UILabel!
    
    @IBOutlet weak var productionCompaniesData: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var movieForFavorite: Movie?
    weak var delegate: MovieDetailHeaderViewDelegate?
    // MARK: - Lifecycle
       override func awakeFromNib() {
           super.awakeFromNib()
       }

       static func makeFromNib() -> MovieDetailHeaderView {
           let nib = UINib(nibName: "MovieDetailHeaderView", bundle: nil)
           // Owner: nil çünkü File’s Owner kullanmıyoruz
           return nib.instantiate(withOwner: nil, options: nil).first as! MovieDetailHeaderView
       }

       // MARK: - Configure
       func configure(with detail: MovieDetail) {
           movieTitle.text = detail.title
           overviewLabel.text = detail.overview

           originalTitleLabel.text        = "detail_original_title_label".localized
           originalTitleDataLabel.text    = detail.originalTitle
           originalLanguageLabel.text     = "detail_original_language_label".localized
           originalLanguageDataLabel.text = detail.originalLanguage.uppercased()

           releaseDateLabel.text = "detail_release_date_label".localized
           releaseDateData.text  = detail.releaseDate.formattedDate
           budgetLabel.text      = "detail_budget_label".localized
           budgetData.text       = detail.budget.formattedCurrency
           productionCompaniesLabel.text = "detail_production_companies_label".localized
           productionCompaniesData.text = detail.productionCompanies.map{ $0.name}.joined(separator: ", ")
           
           revenueLabel.text = "detail_revenue_label".localized
           revenueData.text  = detail.revenue.formattedCurrency
           genresLabel.text  = "detail_genres_label".localized
           genresData.text   = detail.genres.map { $0.name }.joined(separator: ", ")

           runtimeLabel.text = "detail_runtime_label".localized
           if let rt = detail.runtime { runtimeData.text = String(format: "detail_runtime_minutes".localized, rt) }

           if let path = detail.posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
               URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                   guard let data = data else { return }
                   DispatchQueue.main.async { self?.imageView.image = UIImage(data: data) }
               }.resume()
           }
           
           // MovieDetail -> Movie (CoreDataManager bu imzayı bekliyor)
           movieForFavorite = Movie(
               id: detail.id,
               title: detail.title,
               posterPath: detail.posterPath,
               overview: detail.overview,
               releaseDate: detail.releaseDate,
               voteAverage: detail.voteAverage,
               genreIDs: detail.genres.map { $0.id }
           )
           updateFavoriteIcon()

       }
    
    private func updateFavoriteIcon() {
        guard let m = movieForFavorite else { return }
        let isFav = CoreDataManager.shared.isFavorite(movieID: m.id)
        let imgName = isFav ? "heart.fill" : "heart"
        let img = UIImage(systemName: imgName)?.withRenderingMode(.alwaysOriginal)
        favoriteButton.setImage(img, for: .normal)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let m = movieForFavorite else { return }

        if CoreDataManager.shared.isFavorite(movieID: m.id) {
            CoreDataManager.shared.removeFromFavorites(movieID: m.id)
        } else {
            CoreDataManager.shared.addToFavorites(movie: m)
        }

        updateFavoriteIcon()

        let isFavNow = CoreDataManager.shared.isFavorite(movieID: m.id)
        delegate?.movieDetailHeaderViewDidToggleFavorite(self, isFavorite: isFavNow)
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: m.id)
    }
   }
