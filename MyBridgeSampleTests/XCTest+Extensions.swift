//
//  XCTest+Extensions.swift
//  MyBridgeSampleTests
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import XCTest
@testable import MyBridgeSample
import RealmSwift

// MARK: - JSONDecoder

extension XCTestCase {
    func decodeJSON<T: Decodable>(_ type: T.Type, from: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: from, options: [])
        return try JSONDecoder().decode(type, from: data)
    }

    func decodeJSONString<T: Decodable>(_ type: T.Type, from: String) throws -> T {
        let data = from.data(using: .utf8)!
        return try JSONDecoder().decode(type, from: data)
    }
}


// MARK: - Realm

extension XCTestCase {
    func prepareRealm(identifier: String) -> Realm {
        let realm = try! Realm(configuration: Realm.Configuration(
            inMemoryIdentifier: identifier,
            objectTypes: [FavoriteUser.self])
        )
        return realm
    }
}


// MARK: - sample data

extension XCTestCase {
    func prepareFavoriteUsers(realm: Realm) {
        // users.json
        let data: [Any] = [
            [21292, "twilson63", "https://avatars3.githubusercontent.com/u/21292?v=4"], // [9]
            [58276, "tomnomnom", "https://avatars1.githubusercontent.com/u/58276?v=4"], // [4]
            [145676, "tomayac", "https://avatars3.githubusercontent.com/u/145676?v=4"], // [29]
            [748, "tom", "https://avatars1.githubusercontent.com/u/748?v=4"], // [0]
            [3192, "tomstuart", "https://avatars2.githubusercontent.com/u/3192?v=4"], // [27]
            [1, "mojombo", "https://avatars0.githubusercontent.com/u/1?v=4"], // [2]
            [945979, "dribnet", "https://avatars3.githubusercontent.com/u/945979?v=4"], // [21]
        ]
        try! realm.write {
            data.forEach { (d) in
                let obj = FavoriteUser(value: d)
                realm.add(obj)
            }
        }
        realm.refresh()
    }

    func sampleUserJSONString() -> String {
        let json = """
        {
            "login": "addtest",
            "id": 32035,
            "avatar_url": "https://avatars3.githubusercontent.com/u/32035?v=4"
        }
        """
        return json
    }
}
