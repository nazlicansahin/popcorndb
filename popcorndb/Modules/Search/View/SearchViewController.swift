//
//  SearchViewController.swift
//  popcorndb
//
//  Created by Nazlı on 11.08.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let viewModel = SearchViewModel()
    private let refreshControl = UIRefreshControl()

    // Basit genre map (istersen gerçek endpoint ile doldur)
    private let genreMap: [Int: String] = [
        28:"Action",12:"Adventure",16:"Animation",35:"Comedy",80:"Crime",
        18:"Drama",14:"Fantasy",27:"Horror",10749:"Romance",878:"Sci‑Fi"
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadInitial()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // favori ikonları güncellensin
    }
    
    

    // MARK: - UI
    private func setupUI() {
        title = "search_title".localized
        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 96
        tableView.estimatedRowHeight = 96
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil),
                           forCellReuseIdentifier: SearchResultTableViewCell.reuseID)

        // Header (Search bar)
        let header = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
        header.configure(placeholder: "search_placeholder".localized)
        header.onQueryChange = { [weak self] q in 
            self?.viewModel.setQueryDebounced(q) 
        }
        header.onSearchButtonTapped = { [weak self] q in 
            self?.viewModel.searchImmediately(q) 
        }
        header.onCancelTapped = { [weak self] in 
            self?.viewModel.loadInitial() 
        }

        tableView.tableHeaderView = header
        // header yüksekliğini oturt
        header.frame.size.height = header.intrinsicContentSize.height
        
        // Refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleStateChange(state)
            }
        }
        viewModel.onMoviesUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Actions
    @objc private func refreshData() {
        viewModel.refresh()
    }

    // MARK: - State
    private func handleStateChange(_ state: SearchState) {
        refreshControl.endRefreshing()
        switch state {
        case .idle: break
        case .loading: break // istersen spinner göster
        case .loaded(let items):
            items.isEmpty ? showEmptyState() : hideEmptyState()
        case .empty:
            showEmptyState()
        case .error(let err):
            showError(err)
        }
    }

    private func showEmptyState() {
        let v = UIView()
        let img = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        img.tintColor = .systemGray3
        img.translatesAutoresizingMaskIntoConstraints = false
        let lbl = UILabel()
        lbl.text = "search_empty".localized
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(img); v.addSubview(lbl)
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            img.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: -20),
            img.widthAnchor.constraint(equalToConstant: 60),
            img.heightAnchor.constraint(equalToConstant: 60),
            lbl.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 16),
            lbl.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        tableView.backgroundView = v
    }

    private func hideEmptyState() { tableView.backgroundView = nil }

    private func showError(_ error: NetworkError) {
        let ac = UIAlertController(title: "general_error_title".localized, message: error.description, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "general_ok".localized, style: .default))
        present(ac, animated: true)
    }
}

// MARK: - Table
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseID,
            for: indexPath
        ) as! SearchResultTableViewCell

        cell.configure(with: viewModel.movies[indexPath.row], genreMap: genreMap)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movies[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movieID = movie.id
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeeded(around: indexPath.row)
    }
}

// MARK: - Favorite callback
extension SearchViewController: SearchResultCellDelegate {
    func searchResultCellDidToggleFavorite(_ cell: SearchResultTableViewCell, movie: Movie, isNewFavorite: Bool) {
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
}

