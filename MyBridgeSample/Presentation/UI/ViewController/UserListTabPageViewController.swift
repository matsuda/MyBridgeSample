//
//  UserListTabPageViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/24.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import TabPageViewController

final class UserListTabPageViewController: TabPageViewController {

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let vc1 = SearchUserListViewController.make()
        let vc2 = FavoriteUserListViewController.make()
        tabItems = [(vc1, "API"), (vc2, "ローカル")]
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        option.fontSize = 17
        option.hidesTopViewOnSwipeType = .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


// MARK: - TabPageContentViewControllerType

protocol TabPageContentViewControllerType {
    var tabPageContentScrollView: UIScrollView? { get }
    func prepareTabPage()
}

extension TabPageContentViewControllerType where Self: UIViewController {
    func prepareTabPage() {
        guard parent is UserListTabPageViewController,
            let scrollView = tabPageContentScrollView else {
                return
        }
        let tabHeight = TabPageOption().tabHeight
        scrollView.contentInset.top = tabHeight
        let offset = CGPoint(x: 0, y: -tabHeight)
        scrollView.setContentOffset(offset, animated: false)
    }
}
