//
//  URLResource.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - URLResource

public protocol URLResource {
    var url: URL? { get }
}


// MARK: - URL

extension URL: URLResource {
    public var url: URL? { self }
}


// MARK: - String

extension String: URLResource {
    public var url: URL? { URL(string: self) }
}
