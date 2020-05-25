//
//  UserListCell.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class UserListCell: UITableViewCell {

    @IBOutlet private weak var avatarIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoriteButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - public

extension UserListCell {
    func configure(user: User) {
        nameLabel.text = user.name
        setFavoriteImage(isFavorite: user.isFavorite)
        avatarIcon.loadImage(with: user.avatarUrl)
    }
}


// MARK: - private

extension UserListCell {
    private func setFavoriteImage(isFavorite: Bool) {
        if isFavorite {
            let image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.imageView?.tintColor = .githubBgColor
        } else {
            let image = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.imageView?.tintColor = .systemGray
        }
    }
}
