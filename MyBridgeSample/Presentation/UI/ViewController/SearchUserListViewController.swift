//
//  SearchUserListViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class SearchUserListViewController: UIViewController {

    // UIs
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        loadData()
    }
}


// MARK: - private

extension SearchUserListViewController {
    private func prepareTableView() {
    }

    private func loadData() {
        guard let path = Bundle.main.path(forResource: "users", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        guard let userList = try? JSONDecoder().decode(GitHubUserList.self, from: data) else {
            return
        }
        users = userList.users.map {
            User(gitHubUser: $0)
        }
    }
}


// MARK: - UITableViewDataSource

extension SearchUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        return cell!
    }
}


// MARK: - UITableViewDelegate

extension SearchUserListViewController: UITableViewDelegate {
}
