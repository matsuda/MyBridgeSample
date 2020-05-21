//
//  FavoriteUser.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteUser: Object {
    dynamic var userID = 0
    dynamic var name = ""
    dynamic var imageURL = ""

    override static func indexedProperties() -> [String] {
        return ["userID", "name"]
    }
}
