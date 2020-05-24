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


// MARK: - GitHubUser

extension GitHubUser {
    init(user: API.User) {
        self.init(id: user.id, login: user.login, avatarUrl: user.avatarUrl)
    }
}


#if DEBUG
final class SearchUserRepositoryStub: SearchUserRepository {
    func search(keyword: String, page: Int?) -> Single<[GitHubUser]> {
        Single<[GitHubUser]>.create { (observer) -> Disposable in
            if let users = self.loadData()?.users {
                observer(.success(users))
            } else {
                observer(.success([]))
            }
            return Disposables.create()
        }
    }

    private func loadData() -> GitHubUserList? {
        guard let path = Bundle.main.path(forResource: "users", ofType: "json") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil}
        guard let userList = try? JSONDecoder().decode(GitHubUserList.self, from: data) else {
            return nil
        }
        return userList
    }
}
#endif
