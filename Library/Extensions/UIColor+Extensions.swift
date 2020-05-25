//
//  UIColor+Extensions.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        let red: CGFloat = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
