//
//  SearchHeaderView.swift
//  popcorndb
//
//  Created by Nazlı on 11.08.2025.
//

import UIKit

final class SearchHeaderView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Callbacks
     var onQueryChange: ((String) -> Void)?
     var onSearchButtonTapped: ((String) -> Void)?
     var onCancelTapped: (() -> Void)?

     override var intrinsicContentSize: CGSize {
         CGSize(width: UIView.noIntrinsicMetric, height: 56)
     }

     func configure(placeholder: String = "Search for movies") { searchBar.placeholder = placeholder }
     func setQuery(_ text: String) { searchBar.text = text }
     func activateSearchBar() { searchBar.becomeFirstResponder() }

     // Debounce
     private var debounceWorkItem: DispatchWorkItem?
     private let debounceInterval: TimeInterval = 1.0

     // MARK: - Init
     override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }

     deinit { debounceWorkItem?.cancel() }

     private func commonInit() {
         // File’s Owner pattern
         Bundle.main.loadNibNamed("SearchHeaderView", owner: self, options: nil)
         addSubview(contentView)
         contentView.frame = bounds
         contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         searchBar.delegate = self
         searchBar.returnKeyType = .search
         searchBar.enablesReturnKeyAutomatically = false
         searchBar.searchTextField.clearButtonMode = .whileEditing
         if #available(iOS 13.0, *) {
             searchBar.searchTextField.backgroundColor = .systemGray6
             searchBar.searchTextField.layer.cornerRadius = 10
             searchBar.searchTextField.layer.masksToBounds = true
         }
         searchBar.backgroundImage = UIImage()
         searchBar.backgroundColor = .systemBackground
     }
 }

 // MARK: - UISearchBarDelegate
 extension SearchHeaderView: UISearchBarDelegate {
     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBar.setShowsCancelButton(true, animated: true)
     }

     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         searchBar.setShowsCancelButton(false, animated: true)
     }

     func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
         debounceWorkItem?.cancel()
         let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
         let work = DispatchWorkItem { [weak self] in 
             self?.onQueryChange?(trimmed) 
         }
         debounceWorkItem = work
         DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: work)
     }

     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         debounceWorkItem?.cancel()
         let trimmed = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
         onSearchButtonTapped?(trimmed)
         searchBar.resignFirstResponder()
     }

     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.text = ""
         debounceWorkItem?.cancel()
         onCancelTapped?()
         searchBar.resignFirstResponder()
     }
 }
