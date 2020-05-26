//
//  SearchUserRepository.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import API

// MARK: - WebAPI

protocol WebAPIProtocol {
    func search(keyword: String, page: Int?) -> Single<[API.User]>
}


final class SearchUserRepositoryImpl: SearchUserRepository {
    let webAPI: WebAPIProtocol

    init(webAPI: WebAPIProtocol) {
        self.webAPI = webAPI
    }

    func search(keyword: String, page: Int? = nil) -> Single<[GitHubUser]> {
        return webAPI.search(keyword: keyword, page: page)
            .map({ users in
                users
                    .map(GitHubUser.init(user:))
                    .sorted(by: { $0.login.lowercased() < $1.login.lowercased() })
            })
    }
}


// MARK: - GitHubUser

extension GitHubUser {
    init(user: API.User) {
        self.init(id: user.id, login: user.login, avatarUrl: user.avatarUrl)
    }
}
