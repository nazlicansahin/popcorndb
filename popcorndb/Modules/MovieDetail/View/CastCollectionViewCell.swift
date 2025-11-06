//
//  CastCollectionViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 5.08.2025.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    // XIB’de bağlayın:
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var characterLabel: UILabel?

    static let reuseID = "CastCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        nameLabel?.text = nil
        characterLabel?.text = nil
    }

    func configure(with cast: Cast) {
        nameLabel?.text = cast.name
        characterLabel?.text = cast.character

        if let url = cast.profileURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.imageView?.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
