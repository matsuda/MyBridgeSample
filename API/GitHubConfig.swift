//
//  GitHubConfig.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public class GitHubConfig {
    public static let shared: GitHubConfig = .init()

    public var token: String?

    private init() {}
}
