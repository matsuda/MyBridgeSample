//
//  FavoriteUserRepository.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

typealias FavoriteActionCompletion = (Result<(Int, Bool), Error>) -> Void

final class FavoriteUserRepositoryImpl: FavoriteUserRepository {
    private let realm: Realm

    init(realm: Realm!) {
        self.realm = realm
    }

    func fetchBy(id: Int) -> User? {
        FavoriteUser.find(realm, id: id)
            .map { User(favoriteUser: $0) }
    }

//    func fetchBy(likeName name: String) -> [User] {
//        FavoriteUser.find(realm, likeName: name)
//            .map { User(favoriteUser: $0) }
//    }

//    func add(user: User) {
//        let obj = FavoriteUser(user: user)
//        try? realm.write {
//            realm.add(obj)
//        }
//    }
//
//    func remove(id: Int) {
//        try? FavoriteUser.delete(realm, id: id)
//    }

    func fetchBy(likeName name: String) -> Single<[User]> {
        let single = Single<[User]>.create { (observer) -> Disposable in
            let results = FavoriteUser.find(self.realm, likeName: name)
                .map { User(favoriteUser: $0) }
            observer(.success(Array(results)))
            return Disposables.create()
        }
        return single
    }

    func add(user: User) -> Single<Bool> {
        let single = Single<Bool>.create { (observer) -> Disposable in
            let obj = FavoriteUser(user: user)
            do {
                try self.realm.write {
                    self.realm.add(obj)
                }
                observer(.success(true))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
        return single
    }

    func remove(id: Int) -> Single<Bool> {
        let single = Single<Bool>.create { (observer) -> Disposable in
            do {
                try FavoriteUser.delete(self.realm, id: id)
                observer(.success(false))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
        return single
    }
}


// MARK: - FavoriteUser

extension FavoriteUser {
    convenience init(user: User) {
        self.init()
        id = user.id
        name = user.name
        avatarUrl = user.avatarUrl
    }
}
