//
//  SearchUserRepository.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift

final class SearchUserRepositoryImpl: SearchUserRepository {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func search(keyword: String, page: Int? = nil) -> Single<[GitHubUser]> {
        let request = SearchUserRequest(q: keyword, page: page)
        return session.response(request: request)
            .map { searchUserResponse in
                searchUserResponse.element.users.map(GitHubUser.init(user:))
        }
    }
}

extension GitHubUser {
    init(user: API.User) {
        self.init(id: user.id, login: user.login, avatarUrl: user.avatarUrl)
    }
}
