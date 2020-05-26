//
//  WebAPI.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/26.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift

// MARK: - Session

extension Session: WebAPIProtocol {
    func search(keyword: String, page: Int?) -> Single<[API.User]> {
        let request = SearchUserRequest(q: keyword, page: page)
        return response(request: request)
            .map({ $0.element.users })
    }
}
