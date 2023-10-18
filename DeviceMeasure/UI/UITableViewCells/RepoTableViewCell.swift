//
//  RepoTableViewCell.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 27/06/2022.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var ownerNameLabel: RegularLabel!
    @IBOutlet weak var repoNameLabel: SemiBoldLabel!
    @IBOutlet weak var descriptionLabel: CaptionLabel!
    @IBOutlet weak var languageLabel: RegularLabel!
    @IBOutlet weak var starCountLabel: RegularLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with viewModel: RepoTableViewCellViewModel) {
        ownerNameLabel.text = viewModel.item.owner?.login
        avatarImageView.imageFromUrl(urlString: viewModel.item.owner?.avatarURL)
        repoNameLabel.text = viewModel.item.name
        descriptionLabel.text = viewModel.item.description
        languageLabel.text = viewModel.item.language
        starCountLabel.text = String(viewModel.item.stargazersCount ?? 0)
    }
}
