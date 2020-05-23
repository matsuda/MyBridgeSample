//
//  UserRealm.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

func userRealm() throws -> Realm {
    return try UserRealm.realm()
}

enum UserRealm {
    static func realm() throws -> Realm {
        return try Realm(configuration: configuration)
    }

    static var configuration: Realm.Configuration {
        let objectTypes: [RealmSwift.Object.Type] = [
            FavoriteUser.self,
        ]

        let migrationBlock: RealmSwift.MigrationBlock = { migration, oldSchemaVersion in
            print("UserRealm migration block start")
            if oldSchemaVersion < 1 {}
            print("UserRealm migration block complete.")
        }

        return Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: UInt64(schemaVersion),
            migrationBlock: migrationBlock,
            objectTypes: objectTypes)
    }

    private static var fileURL: URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: path).appendingPathComponent(filename)
    }

    private static let filename: String = "user.realm"

    private static let schemaVersionInfoKeky: String = "User Realm Scheme Version"

    private static var schemaVersion: Int {
        guard let version = Bundle.main.infoDictionary?[schemaVersionInfoKeky] as? Int else {
            fatalError("Not found '\(schemaVersionInfoKeky)' in Info.plist")
        }
        return version
    }
}
