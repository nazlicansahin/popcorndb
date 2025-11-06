//
//  FavoritesTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 2.08.2025.
//
import UIKit
import Foundation

protocol FavoritesCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: FavoritesCollectionViewCell)
}

protocol FavoritesTableViewCellDelegate: AnyObject {
    func favoritesTableViewCellDidUpdateFavorites(_ cell: FavoritesTableViewCell)
    func favoritesTableViewCell(_ cell: FavoritesTableViewCell, didSelectFavoriteWithID id: Int)
}

class FavoritesTableViewCell: UITableViewCell,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout,
                              FavoritesCollectionViewCellDelegate {

    weak var delegate: FavoritesTableViewCellDelegate?

    private var movies: [Any] = []

    @IBOutlet weak var collectionView: UICollectionView!

    func configure(with movies: [Any]) {
        self.movies = movies
        collectionView.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(
            UINib(nibName: "FavoritesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "FavoritesCollectionViewCell"
        )

        collectionView.dataSource = self
        collectionView.delegate   = self

        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
            flow.minimumLineSpacing = 12
            flow.minimumInteritemSpacing = 8
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FavoritesCollectionViewCell",
            for: indexPath
        ) as! FavoritesCollectionViewCell

        let item = movies[indexPath.item]
        if let favoriteMovie = item as? FavoriteMovieEntity {
            cell.configure(with: favoriteMovie)
        } else if let rv = item as? RecentlyViewedItem {
            cell.configure(with: rv)
        }

        cell.delegate = self
        return cell
    }

    // MARK: - FlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 210, height: 350)
    }

    // MARK: - FavoritesCollectionViewCellDelegate
    func didTapFavoriteButton(in cell: FavoritesCollectionViewCell) {
        delegate?.favoritesTableViewCellDidUpdateFavorites(self)
        // Reload the collection to reflect updated titles/images
        collectionView.reloadData()
    }
}

// MARK: - Selection -> VC'ye ID gönder
extension FavoritesTableViewCell {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let fav = movies[indexPath.item] as? FavoriteMovieEntity {
            delegate?.favoritesTableViewCell(self, didSelectFavoriteWithID: Int(fav.id))
        } else if let rv = movies[indexPath.item] as? RecentlyViewedItem {
            delegate?.favoritesTableViewCell(self, didSelectFavoriteWithID: rv.id)
        }
    }
}
