//
//  NibLoadable.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

// MARK: - NibLoadable

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
    var nibName: String { get }
    var bundle: Bundle { get }
    func loadFromNib(options: [UINib.OptionsKey: Any]?)
}

public extension NibLoadable {
    static var nibName: String {
        String(describing: self)
    }
    var nibName: String {
        type(of: self).nibName
    }
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
    func loadFromNib(options: [UINib.OptionsKey: Any]? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: options)
    }
}


// MARK: - UIView extension

extension UIView: NibLoadable {}

public extension NibLoadable where Self: UIView {
    static func loadNib() -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}
