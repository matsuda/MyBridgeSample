//
//  UITableView+Extensions.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    public func registerNib<T: UITableViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }

    public func registerClass<T: UITableViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        register(T.self, forCellReuseIdentifier: identifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = T.reusableIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(identifier).")
        }
        return cell
    }

    public func registerNib<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func registerClass<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        let identifier = T.reusableIdentifier
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Could not dequeue HeaderFooterView: \(T.self) with identifier: \(identifier).")
        }
        return view
    }
}


extension UITableView {
    public func deselectRow(animated: Bool = true) {
        if let indexPath = indexPathForSelectedRow {
            deselectRow(at: indexPath, animated: animated)
        }
    }

    public func sizeToFitHeaderView() {
        guard let view = tableHeaderView else {
            return
        }
        let current = view.frame
        let frame = systemLayoutFittingFrame(view)
        if !current.equalTo(frame) {
            tableHeaderView = view
        }
    }

    public func sizeToFitFooterView() {
        guard let view = tableFooterView else {
            return
        }
        let current = view.frame
        let frame = systemLayoutFittingFrame(view)
        if !current.equalTo(frame) {
            tableFooterView = view
        }
    }

    private func systemLayoutFittingFrame(_ view: UIView) -> CGRect {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var frame = view.frame
        frame.size.height = size.height
        view.frame = frame
        return frame
    }
}
