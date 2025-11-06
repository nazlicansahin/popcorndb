//
//  CastHeaderTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 10.08.2025.
//
import UIKit

final class CastHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var biographyTitleLabel: UILabel!
    @IBOutlet weak var biographyDataLabel: UILabel!

    override func awakeFromNib() {
         super.awakeFromNib()
         avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
         avatarImageView.layer.borderWidth = 2
         avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
         avatarImageView.clipsToBounds = true
         selectionStyle = .none
     }

     func configure(name: String, role: String, biography: String, imageURL: URL?) {
         nameLabel.text = name
         roleLabel.text = role
         biographyTitleLabel.text = "person_biography".localized
         biographyDataLabel.text = biography.isEmpty ? "person_no_biography".localized : biography

         avatarImageView.image = nil
         if let url = imageURL {
             URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                 guard let data = data else { return }
                 DispatchQueue.main.async {
                     self?.avatarImageView.image = UIImage(data: data)
                 }
             }.resume()
         }
     }
 }
