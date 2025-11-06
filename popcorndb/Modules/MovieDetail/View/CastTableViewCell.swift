//
//  CastTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 7.08.2025.
//

import UIKit
protocol CastTableViewCellDelegate: AnyObject {
    func castTableViewCell(_ cell: CastTableViewCell, didSelect cast: Cast)
}
class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    private var items: [Cast] = []
    weak var delegate: CastTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        // XIB kaydı
        let nib = UINib(nibName: "CastCollectionViewCell", bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: CastCollectionViewCell.reuseID)

        collectionView.dataSource = self
        collectionView.delegate   = self

        // Yatay akış & aralıklar
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
            flow.minimumLineSpacing = 12
            flow.minimumInteritemSpacing = 8
        }

        collectionView.showsHorizontalScrollIndicator = false
        selectionStyle = .none
    }

    // Dışarıdan veri bağla
    func configure(with cast: [Cast]) {
        self.items = cast
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CastTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastCollectionViewCell.reuseID,
            for: indexPath
        ) as! CastCollectionViewCell

        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.castTableViewCell(self, didSelect: items[indexPath.item])
    }

    // Hücre boyutu: koleksiyon yüksekliğine göre ayarla
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.bounds.height
        return CGSize(width: 120, height: h - 4)
    }
}
