//
//  EmptyView.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class EmptyView: UIView {

    @IBOutlet private weak var textLabel: UILabel!

    var text: String? {
        get { textLabel.text }
        set { textLabel.text = newValue }
    }
}
