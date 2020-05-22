//
//  User.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let avatarUrl: String?
    var isFavorite: Bool

    init(gitHubUser: GitHubUser, isFavorite: Bool = false) {
        id = gitHubUser.id
        name = gitHubUser.login
        avatarUrl = gitHubUser.avatarUrl
        self.isFavorite = isFavorite
    }

    init(favoriteUser: FavoriteUser) {
        id = favoriteUser.userID
        name = favoriteUser.name
        avatarUrl = favoriteUser.avatarUrl
        isFavorite = true
    }
}
