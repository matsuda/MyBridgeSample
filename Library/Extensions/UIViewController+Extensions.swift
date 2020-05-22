//
//  UIViewController+Extensions.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

extension UIViewController {
    public static func make() -> Self {
        let identifier = String(describing: Self.self)
        return instantiate(storyboardName: identifier)
    }

    private static func instantiate<T>(storyboardName: String) -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
            ?? storyboard.instantiateViewController(withIdentifier: storyboardName)
        return vc as! T
    }
}
