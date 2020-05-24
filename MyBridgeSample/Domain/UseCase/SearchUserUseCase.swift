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
//    func like(user: User) -> Single<User?>
    func like(user: User) -> Single<Bool>
}


// MARK: - SearchUserRepository

protocol SearchUserRepository {
    func search(keyword: String, page: Int?) -> Single<[GitHubUser]>
}


final class SearchUserUseCaseImpl: SearchUserUseCase {
    private let repository: SearchUserRepository
    private let favoriteUserRepository: FavoriteUserRepository

    init(repository: SearchUserRepository,
         favoriteUserRepository: FavoriteUserRepository) {
        self.repository = repository
        self.favoriteUserRepository = favoriteUserRepository
    }

    func search(keyword: String, page: Int? = nil) -> Single<[User]> {
        repository
            .search(keyword: keyword, page: page)
            .map({ users in
                users.map({ user in
                    let isLike = self.favoriteUserRepository.fetchBy(id: user.id) != nil
                    return User(gitHubUser: user, isFavorite: isLike)
                })
            })
    }

    func like(user: User) -> Single<Bool> {
        if user.isFavorite {
            return favoriteUserRepository.remove(id: user.id)
        } else {
            return favoriteUserRepository.add(user: user)
        }
    }
}
