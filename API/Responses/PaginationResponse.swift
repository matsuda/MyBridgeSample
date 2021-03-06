//
//  PaginationResponse.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public protocol PaginationResponse {
    associatedtype Element: Decodable

    var element: Element { get }
    var nextPage: Int? { get }

    init(element: Element, nextPage: Int?)
}
