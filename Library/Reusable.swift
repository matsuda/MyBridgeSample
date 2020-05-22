//
//  Reusable.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - Reusable

public protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    public static var reusableIdentifier: String {
        String(describing: self)
    }
}
