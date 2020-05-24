//
//  FavoriteUser.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteUser: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var avatarUrl: String? = nil

    override static func indexedProperties() -> [String] {
        return ["id", "name"]
    }
}


// MARK: - Realm

extension Results where Element: FavoriteUser {
    func orderd() -> Results<Element> {
        return sorted(byKeyPath: "name", ascending: true)
    }
}


// MARK: - Finder

extension FavoriteUser {
    static func findAll(_ realm: Realm) -> Results<FavoriteUser> {
        return realm.objects(self).orderd()
    }

    static func find(_ realm: Realm, id: Int) -> FavoriteUser? {
        let predicate = NSPredicate(format: "id == %ld", id)
        return find(realm, condition: predicate).first
    }

    static func find(_ realm: Realm, likeName name: String) -> Results<FavoriteUser> {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", name)
        return find(realm, condition: predicate)
    }

    static func find(_ realm: Realm, condition predicate: NSPredicate) -> Results<FavoriteUser> {
        return realm.objects(self).filter(predicate).orderd()
    }

    static func delete(_ realm: Realm, id: Int) throws {
        let obj = realm.objects(self).filter("id == %ld", id)
        try realm.write {
            realm.delete(obj)
        }
    }
}
