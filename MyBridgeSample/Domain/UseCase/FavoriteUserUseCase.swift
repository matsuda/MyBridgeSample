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
//    func fetchAll() -> Single<[User]>
//    func isExist(user: User) -> Bool
    func fetchAll() -> [User]
    func add(user: User)
    func remove(id: Int)
}


// MARK: - FavoriteUserRepository

protocol FavoriteUserRepository {
    func fetchAll() -> [User]
    func fetchBy(id: Int) -> User?
    func add(user: User)
    func remove(id: Int)
}


// MARK: - FavoriteUserUseCaseImpl

final class FavoriteUserUseCaseImpl: FavoriteUserUseCase {
    private let repository: FavoriteUserRepository
//    private let realm: Realm

    init(repository: FavoriteUserRepository) {
        self.repository = repository
    }

//    init(realm: Realm) {
//        self.realm = realm
//    }

    func fetchAll() -> [User] {
        repository.fetchAll()
    }

    func add(user: User) {
        repository.add(user: user)
    }

    func remove(id: Int) {
        repository.remove(id: id)
    }

//    func fetchAll() -> Single<[User]> {
//        repository
//            .findAll()
//            .map({ favoriteUsers in
//                favoriteUsers.map({
//                    User(favoriteUser: $0)
//                })
//            })
//    }

//    func isExist(user: User) -> Single<Bool> {
//        repository.findBy(id: user.id)
//            .map { $0 != nil}
//    }

//    func add(user: User) {
//        repository.add(user: user)
//    }
}
