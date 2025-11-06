//
//  RecommendationTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 7.08.2025.
//

import UIKit

protocol RecommendationTableViewCellDelegate: AnyObject {
    func recommendationTableViewCell(_ cell: RecommendationTableViewCell, didSelect movie: Movie)
}

class RecommendationTableViewCell: UITableViewCell {


    @IBOutlet weak var collectionView: UICollectionView!
    private var items: [Movie] = []
        weak var delegate: RecommendationTableViewCellDelegate?

        override func awakeFromNib() {
            super.awakeFromNib()

            // Kayıt
            let nib = UINib(nibName: "RecommendationCollectionViewCell", bundle: nil)
            collectionView.register(nib,
                forCellWithReuseIdentifier: RecommendationCollectionViewCell.reuseID)

            collectionView.dataSource = self
            collectionView.delegate   = self

            // Yatay akış
            if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flow.scrollDirection = .horizontal
                flow.minimumLineSpacing = 12
                flow.minimumInteritemSpacing = 8
            }
        }

        func configure(with movies: [Movie]) {
            self.items = movies
            collectionView.reloadData()
        }
    }

    // MARK: - DataSource & Delegate
    extension RecommendationTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            items.count
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendationCollectionViewCell.reuseID,
                for: indexPath
            ) as! RecommendationCollectionViewCell

            let movie = items[indexPath.item]
            let isFav = CoreDataManager.shared.isFavorite(movieID: movie.id)
            cell.configure(with: movie, isFavorite: isFav)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.recommendationTableViewCell(self, didSelect: items[indexPath.item])
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 160, height: 300) // ufak bir pay
        }
        // RecommendationTableViewCell.swift içinde
        func reloadItem(withMovieID id: Int) {
            if let i = items.firstIndex(where: { $0.id == id }) {
                collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
            }
        }
    }
