//
//  PaginationRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public protocol PaginationRequest: GitHubRequest where Response: PaginationResponse {
    var nextPageKey: String { get }
    var page: Int? { get set }
}

extension PaginationRequest {
    public var queryParameters: [String: Any]? {
        paginationParameters
    }

    var paginationParameters: [String: Any]? {
        if let page = page {
            return [nextPageKey: page]
        }
        return nil
    }
}
