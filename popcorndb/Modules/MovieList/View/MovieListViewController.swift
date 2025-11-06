//
//  MovieListViewController.swift
//  popcorndb
//
//  Created by Nazlı on 29.07.2025.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        tableView.register(
            UINib(nibName: "MovieCategoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MovieCategoryTableViewCell"
        )
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Her section, bir yatay scroll (CollectionView) içerir
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 // Hücre yüksekliği
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title // Başlık olarak "Popular", "Top Rated" vs.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCategoryTableViewCell",
            for: indexPath
        ) as? MovieCategoryTableViewCell else {
            return UITableViewCell()
        }

        let section = viewModel.sections[indexPath.section]
        
        // Delegate bağlantısı burada
        cell.delegate = self

        viewModel.fetchMovies(for: section) { movies in
            DispatchQueue.main.async {
                cell.configure(with: movies)
            }
        }

        return cell
    }
}
extension MovieListViewController: MovieCategoryTableViewCellDelegate {
    func didSelectMovie(_ movie: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movieID = movie.id
        detailVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
