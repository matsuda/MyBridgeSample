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
    let imageURL: String?
    var isFav: Bool

    init(gitHubUser: GitHubUser, isFav: Bool = false) {
        id = gitHubUser.id
        name = gitHubUser.login
        imageURL = gitHubUser.avatarUrl
        self.isFav = isFav
    }

    init(favoriteUser: FavoriteUser) {
        id = favoriteUser.userID
        name = favoriteUser.name
        imageURL = favoriteUser.imageURL
        isFav = true
    }
}
