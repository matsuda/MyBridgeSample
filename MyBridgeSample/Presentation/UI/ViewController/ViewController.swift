//
//  ViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/20.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "GitHub Stars"
//        loadSearchUserList()
        loadFavoriteUserList()
    }
}

extension ViewController {
    private func loadSearchUserList() {
        let vc = SearchUserListViewController.make()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
        vc.didMove(toParent: self)
    }

    private func loadFavoriteUserList() {
        let vc = FavoriteUserListViewController.make()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
        vc.didMove(toParent: self)
    }
}
