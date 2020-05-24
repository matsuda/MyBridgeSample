//
//  UserListContainerViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/20.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library

final class UserListContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "GitHub Stars"
    }
}

#if DEBUG
extension UserListContainerViewController {
    private func loadSearchUserList() {
        let vc = SearchUserListViewController.make()
        addChildAndSubview(vc)
    }

    private func loadFavoriteUserList() {
        let vc = FavoriteUserListViewController.make()
        addChildAndSubview(vc)
    }

    private func addChildAndSubview(_ vc: UIViewController) {
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
#endif
