//
//  FavoriteUserRepository.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteUserRepositoryImpl: FavoriteUserRepository {
    private let realm: Realm

    init(realm: Realm!) {
        self.realm = realm
    }

    func fetchAll() -> [User] {
        FavoriteUser
            .findAll(realm)
            .map { User(favoriteUser: $0) }
    }

    func fetchBy(id: Int) -> User? {
        FavoriteUser.find(realm, id: id)
            .map { User(favoriteUser: $0) }
    }

    func add(user: User) {
        let obj = FavoriteUser(user: user)
        try! realm.write {
            realm.add(obj)
        }
    }

    func remove(id: Int) {
        try! FavoriteUser.delete(realm, id: id)
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
