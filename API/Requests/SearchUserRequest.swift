//
//  SearchUserRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - UserListRequest

public struct SearchUserRequest: GitHubRequest, PaginationRequest {
    public typealias Response = SearchUserResponse<SearchUserList>

    public var path: String = "/search/users"

    public var q: String
    public let nextPageKey: String = "since"
    public var page: Int?

    public init(q: String, page: Int? = nil) {
        self.q = q
        self.page = page
    }

    public var queryParameters: [String: Any]? {
        var params: [String: Any] = [
            "q": q
        ]
        if let value = paginationParameters {
            params.merge(value) { $1 }
        }
        return params
    }
}
