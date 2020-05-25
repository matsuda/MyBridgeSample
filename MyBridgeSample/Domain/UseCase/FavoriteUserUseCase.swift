//
//  FavoriteUserUseCase.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - FavoriteUserUseCaseImple

protocol FavoriteUserUseCase {
    func search(name: String) -> Single<[User]>
    func add(user: User) -> Single<Bool>
    func remove(id: Int) -> Single<Bool>
}


// MARK: - FavoriteUserRepository

protocol FavoriteUserRepository {
    func fetchBy(id: Int) -> User?
    func fetchBy(likeName name: String) -> Single<[User]>
    func add(user: User) -> Single<Bool>
    func remove(id: Int) -> Single<Bool>
}


// MARK: - FavoriteUserUseCaseImpl

final class FavoriteUserUseCaseImpl: FavoriteUserUseCase {
    private let repository: FavoriteUserRepository

    init(repository: FavoriteUserRepository) {
        self.repository = repository
    }

    func search(name: String) -> Single<[User]> {
        repository.fetchBy(likeName: name)
    }

    func add(user: User) -> Single<Bool> {
        repository.add(user: user)
    }

    func remove(id: Int) -> Single<Bool> {
        repository.remove(id: id)
    }
}
