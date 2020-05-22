//
//  UIImageView+Extensions.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library
import Nuke

extension UIImageView {
    func loadImage(with resource: URLResource?) {
        guard let url = resource?.url else {
            image = nil
            return
        }
        Nuke.loadImage(with: url, into: self)
    }
}
