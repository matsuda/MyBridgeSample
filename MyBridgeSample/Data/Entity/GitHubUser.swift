//
//  GitHubUser.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

struct GitHubUser: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}
