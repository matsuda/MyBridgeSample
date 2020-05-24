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
    func search(name: String) -> [User]
    func add(user: User)
    func remove(id: Int)
}


// MARK: - FavoriteUserRepository

protocol FavoriteUserRepository {
    func fetchAll() -> [User]
    func fetchBy(id: Int) -> User?
    func fetchBy(likeName name: String) -> [User]
    func add(user: User)
    func remove(id: Int)
}


// MARK: - FavoriteUserUseCaseImpl

final class FavoriteUserUseCaseImpl: FavoriteUserUseCase {
    private let repository: FavoriteUserRepository

    init(repository: FavoriteUserRepository) {
        self.repository = repository
    }

    func search(name: String) -> [User] {
        repository.fetchBy(likeName: name)
    }

    func add(user: User) {
        repository.add(user: user)
    }

    func remove(id: Int) {
        repository.remove(id: id)
    }
}
