//
//  MovieDetailViewController.swift
//  popcorndb
//
//  Created by Nazlı on 5.08.2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movieID: Int?

    // MARK: - State
    private let viewModel = MovieDetailViewModel()
    private var cast: [Cast] = []
    private var recs: [Movie] = []
    private var headerView: MovieDetailHeaderView?


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "nav_home".localized,
            style: .plain,
            target: self,
            action: #selector(goBackToMovies)
        )

        // Table setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableView.automaticDimension

        // Cells
        tableView.register(
            UINib(nibName: "CastTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CastTableViewCell"
        )
        tableView.register(
            UINib(nibName: "RecommendationTableViewCell", bundle: nil),
            forCellReuseIdentifier: "RecommendationTableViewCell"
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteChanged(_:)),
            name: .favoriteStatusChanged,
            object: nil
        )
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoriteStatusChanged, object: nil)
    }
    @objc private func favoriteChanged(_ note: Notification) {
        guard let movieID = note.object as? Int else { return }
        let indexPath = IndexPath(row: 0, section: 1) // Recommended section
        if let recCell = tableView.cellForRow(at: indexPath) as? RecommendationTableViewCell {
            recCell.reloadItem(withMovieID: movieID)
        }
    }
}

// MARK: - Networking / Data
private extension MovieDetailViewController {
    func loadData() {
        guard let id = movieID else { return }

        let group = DispatchGroup()

        // DETAIL
        group.enter()
        viewModel.fetchMovieDetail(id: id) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let detail):
                DispatchQueue.main.async {
                    self?.title = detail.title
                    self?.setupHeader(with: detail)
                    // Add to recently viewed
                    let lightMovie = Movie(
                        id: detail.id,
                        title: detail.title,
                        originalTitle: detail.originalTitle,
                        posterPath: detail.posterPath,
                        backdropPath: detail.backdropPath,
                        overview: detail.overview,
                        releaseDate: detail.releaseDate,
                        voteAverage: detail.voteAverage,
                        voteCount: detail.voteCount,
                        popularity: detail.popularity,
                        genreIDs: detail.genres.map { $0.id },
                        originalLanguage: detail.originalLanguage,
                        adult: detail.adult,
                        video: detail.video
                    )
                    RecentlyViewedManager.shared.add(movie: lightMovie)
                }
            case .failure(let e):
                print("❌ detail error:", e.description)
            }
        }

        // CAST
        group.enter()
        viewModel.fetchCast(id: id) { [weak self] result in
            defer { group.leave() }
            if case .success(let list) = result {
                self?.cast = list
            } else if case .failure(let e) = result {
                print("❌ cast error:", e.description)
            }
        }

        // RECOMMENDATIONS
        group.enter()
        viewModel.fetchRecommendations(id: id) { [weak self] result in
            defer { group.leave() }
            if case .success(let list) = result {
                self?.recs = list
            } else if case .failure(let e) = result {
                print("❌ recs error:", e.description)
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func setupHeader(with detail: MovieDetail) {
        // XIB’den güvenli oluştur
        let hv = MovieDetailHeaderView.makeFromNib()

        hv.delegate = self                 // ← FAVORİ butonu için
        hv.configure(with: detail)
        hv.frame.size.width = tableView.bounds.width

        tableView.tableHeaderView = hv
        headerView = hv
        resizeHeaderToFit()
    }

    func resizeHeaderToFit() {
        guard let header = tableView.tableHeaderView else { return }
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        if header.frame.height != height {
            header.frame.size.height = height
            tableView.tableHeaderView = header
        }
    }
}

// MARK: - UITableView
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 2 } // 0: Cast, 1: Recs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 220 : 260
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "section_cast".localized : "section_recommended".localized
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CastTableViewCell",
                for: indexPath
            ) as! CastTableViewCell
            cell.configure(with: cast)
            cell.delegate = self        // ← cast seçimlerini VC’ye ilet
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecommendationTableViewCell",
                for: indexPath
            ) as! RecommendationTableViewCell
            cell.configure(with: recs)
            cell.delegate = self        // ← öneri seçimlerini VC’ye ilet
            return cell
        }
    }
}

// MARK: - Delegates from inner cells
extension MovieDetailViewController: CastTableViewCellDelegate {
    func castTableViewCell(_ cell: CastTableViewCell, didSelect cast: Cast) {
        // 1) Storyboard’tan CastDetail VC oluştur
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CastDetailViewController") as! CastDetailViewController

        // 2) Seçilen kişiyi aktar
        vc.personID = cast.id
        vc.hidesBottomBarWhenPushed = true

        // 3) Push et
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieDetailViewController: RecommendationTableViewCellDelegate {
    func recommendationTableViewCell(_ cell: RecommendationTableViewCell, didSelect movie: Movie) {
        // Önerilen filme tıklandığında yapılacaklar
        // Storyboard’dan yeni MovieDetailViewController üret
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let next = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        next.movieID = movie.id
        next.hidesBottomBarWhenPushed = true
        
        // Push (sheet istemiyorum demiştin)
        navigationController?.pushViewController(next, animated: true)
        // print("Recommended selected:", movie.title)

    }
    @objc private func goBackToMovies() {
        navigationController?.popToRootViewController(animated: true)
    }
}// MARK: - MovieDetailHeaderViewDelegate
extension MovieDetailViewController: MovieDetailHeaderViewDelegate {
    func movieDetailHeaderViewDidToggleFavorite(_ headerView: MovieDetailHeaderView, isFavorite: Bool) {
        // print("Favori durumu değişti: \(isFavorite)") **sil
        // tableView.reloadData() // gerekirse
    }
}
