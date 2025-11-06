//
//  SearchViewModel.swift
//  popcorndb
//
//  Created by Nazlı on 12.08.2025.
//
import Foundation

// MARK: - Search State
enum SearchState {
    case idle
    case loading
    case loaded([Movie])
    case error(NetworkError)
    case empty
}

final class SearchViewModel {

    // MARK: - State (read-only dışarı)
    private(set) var movies: [Movie] = []
    private(set) var query: String = ""
    private(set) var page: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var currentState: SearchState = .idle

    // Debounce
    private var pendingWorkItem: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 1.0

    // MARK: - Output callbacks
    var onStateChange: ((SearchState) -> Void)?
    var onMoviesUpdate: (() -> Void)?

    // MARK: - Public API
    func setQueryDebounced(_ newQuery: String) {
        pendingWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.applyQuery(newQuery) }
        pendingWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: work)
    }

    func searchImmediately(_ newQuery: String) {
        pendingWorkItem?.cancel()
        applyQuery(newQuery)
    }

    func loadNextPageIfNeeded(around index: Int) {
        guard case .loaded = currentState, !isLoading, page < totalPages else { return }
        if index >= movies.count - 5 {
            page += 1
            fetch()
        }
    }

    func refresh() {
        page = 1
        totalPages = 1
        fetch()
    }

    /// VC ilk açılışta çağırır
    func loadInitial() {
        // print("🔄 loadInitial called")
        query = ""
        page = 1
        totalPages = 1
        movies.removeAll()
        fetch()
    }

    // MARK: - Private
    private var isLoading: Bool {
        if case .loading = currentState { return true }
        return false
    }

    private func applyQuery(_ newQuery: String) {
        let trimmed = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        query = trimmed
        page = 1
        totalPages = 1
        movies.removeAll()
        fetch()
    }

    private func fetch() {
        // print("🔍 fetch() called")
        guard !isLoading else { return }
        
        // Set loading state
        updateState(.loading)
        
        if query.isEmpty {
            // print("📡 Calling fetchPopular")
            fetchPopular(page: page)
        } else {
            // print("🔍 Calling fetchSearch")
            fetchSearch(query: query, page: page)
        }
    }

    private func fetchPopular(page: Int) {
        NetworkManager.shared.request(.popularMovies(page: page),
                                      type: MovieResponse<Movie>.self) { [weak self] result in
            self?.handle(result: result)
        }
    }

    private func fetchSearch(query: String, page: Int) {
        let params = SearchParameters(query: query, page: page, includeAdult: false, language: Language.current)
        NetworkManager.shared.request(.searchMovies(params),
                                      type: MovieResponse<Movie>.self) { [weak self] result in
            self?.handle(result: result)
        }
    }

    private func handle(result: Result<MovieResponse<Movie>, NetworkError>) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch result {
            case .success(let resp):
                print("✅ API Success: \(resp.results.count) movies received")
                self.totalPages = max(resp.totalPages, 1)
                if self.page == 1 { self.movies = resp.results } else { self.movies += resp.results }
                self.updateState(self.movies.isEmpty ? .empty : .loaded(self.movies))
            case .failure(let error):
                print("🔻 SearchVM error:", error.description)
                self.updateState(.error(error))
            }
        }
    }

    private func updateState(_ newState: SearchState) {
        currentState = newState
        onStateChange?(newState)
        onMoviesUpdate?()
    }
}
