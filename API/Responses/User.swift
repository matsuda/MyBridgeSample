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


// MARK: - SearchUserList

public struct SearchUserList: Decodable {
    public let users: [User]

    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}


// MARK: - SearchUserResponse

public struct SearchUserResponse<Element: Decodable>: PaginationResponse {
    public let element: Element
    public let nextPage: Int?

    public init(element: Element, nextPage: Int?) {
        self.element = element
        self.nextPage = nextPage
    }
}
