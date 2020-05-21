//
//  GitHubUserList.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

struct GitHubUserList: Decodable {
    let users: [GitHubUser]

    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}
