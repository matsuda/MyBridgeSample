//
//  FavoriteUserListViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class FavoriteUserListViewController: UIViewController {

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

extension FavoriteUserListViewController {
    private func prepareTableView() {
        tableView.registerNib(UserListCell.self)
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

extension FavoriteUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserListCell.self, for: indexPath)
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension FavoriteUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user = users[indexPath.row]
        user.isFavorite.toggle()
        users[indexPath.row] = user
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
