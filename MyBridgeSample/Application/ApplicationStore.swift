//
//  ApplicationStore.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/24.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ApplicationStore {
    // Singleton
    static let shared = ApplicationStore()

    init() {}

    let didChangeFavorite: PublishSubject<(User, Bool)> = .init()
}
