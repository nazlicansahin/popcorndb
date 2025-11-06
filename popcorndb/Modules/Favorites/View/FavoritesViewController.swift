//
//  FavoritesViewController.swift
//  popcorndb
//
//  Created by Nazlı on 2.08.2025.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesTableViewCellDelegate {
    func favoritesTableViewCellDidUpdateFavorites(_ cell: FavoritesTableViewCell) {
        viewModel.reloadFavorites()
        tableView.reloadData()
    }
    // FavoritesTableViewCellDelegate
    func favoritesTableViewCell(_ cell: FavoritesTableViewCell,
                                didSelectFavoriteWithID id: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = sb.instantiateViewController(
            withIdentifier: "MovieDetailViewController"
        ) as? MovieDetailViewController else { return }

        detailVC.movieID = id
        detailVC.hidesBottomBarWhenPushed = true

        // Restore default push animation
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = FavoritesViewModel()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoritesTableViewCell",
            for: indexPath
        ) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }

        let section = viewModel.sections[indexPath.section]
        let movies = viewModel.movies(for: section)
        cell.configure(with: movies)
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].localizedTitle    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell"
        )
        viewModel.favoriteMovies = CoreDataManager.shared.fetchFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recentlyViewedUpdated), name: .recentlyViewedUpdated, object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadFavorites()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 // Hücre yüksekliği
    }
    
    @objc func favoritesUpdated() {
        viewModel.reloadFavorites()
        tableView.reloadData()
    }

    @objc func recentlyViewedUpdated() {
        // ViewModel recentlyViewedMovies’i güncelliyor; burada sadece tabloyu yenilemek yeterli
        tableView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .recentlyViewedUpdated, object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
