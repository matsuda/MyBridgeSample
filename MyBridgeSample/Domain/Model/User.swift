//
//  User.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

class User {
    let name: String
    let imageURL: String?
    var isFav: Bool = false

    init(gitHubUser: GitHubUser) {
        name = gitHubUser.login
        imageURL = gitHubUser.avatarUrl
    }
}
