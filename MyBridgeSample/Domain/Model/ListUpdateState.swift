//
//  ListUpdateState.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/24.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

enum ListUpdateState {
    case initial(isEmpty: Bool)
    case update(isEmpty: Bool, deletions: [IndexPath], insertiona: [IndexPath], modifications: [IndexPath])
    case error(Error)
}
