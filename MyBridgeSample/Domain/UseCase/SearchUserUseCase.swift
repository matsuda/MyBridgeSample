//
//  SearchUserUseCase.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import RxSwift


// MARK: - SearchUserUseCase

protocol SearchUserUseCase {
    func search(keyword: String, page: Int?) -> Single<[User]>
}


// MARK: - SearchUserRepository

protocol SearchUserRepository {
    func search(keyword: String, page: Int?) -> Single<[GitHubUser]>
}


final class SearchUserUseCaseImpl: SearchUserUseCase {
    private let repository: SearchUserRepository

    init(repository: SearchUserRepository) {
        self.repository = repository
    }

    func search(keyword: String, page: Int? = nil) -> Single<[User]> {
        repository
            .search(keyword: keyword, page: page)
            .map({ gitHubUsers in
                gitHubUsers.map({ gitHubUser in
                    User(gitHubUser: gitHubUser)
                })
            })
    }
}


extension SearchUserUseCaseImpl {
    static func build() -> SearchUserUseCase {
        let repository = SearchUserRepositoryImpl(session: .shared)
        return SearchUserUseCaseImpl(repository: repository)
    }
}
