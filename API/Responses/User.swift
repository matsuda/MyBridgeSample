//
//  User.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - User

public struct User: Decodable {
    public let id: Int
    public let login: String
    public let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}


// MARK: - SearchUserResponse

public struct SearchUserResponse<Element: Decodable>: PaginationResponse {
    public let elements: Element
    public let nextPage: Int?

    public init(elements: Element, nextPage: Int?) {
        self.elements = elements
        self.nextPage = nextPage
    }
}
