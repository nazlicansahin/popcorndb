//
//  InfoRowTableViewCell.swift
//  popcorndb
//
//  Created by Nazlı on 10.08.2025.
//
import UIKit

final class InfoRowTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    static let reuseID = "InfoRowTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = .zero
        layoutMargins = .zero
    }

    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueLabel.text = value?.isEmpty == false ? value : "person_value_empty".localized
    }
}
