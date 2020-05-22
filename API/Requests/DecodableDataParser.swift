//
//  DecodableDataParser.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit

public final class DecodableDataParser: DataParser {
    public var contentType: String? = "application/json"

    public func parse(data: Data) throws -> Any {
        return data
    }
}
