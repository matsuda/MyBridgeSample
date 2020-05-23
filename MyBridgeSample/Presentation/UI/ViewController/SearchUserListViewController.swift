//
//  SearchUserListViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchUserListViewController: UIViewController {

    // UIs
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private lazy var viewModel: SearchUserListViewModel = createViewModel()
    private var users: [User] = []
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        setupObservable()
//        loadData()
    }
}


// MARK: - private

extension SearchUserListViewController {
    private func prepareTableView() {
        tableView.registerNib(UserListCell.self)
    }

    private func createViewModel() -> SearchUserListViewModel {
        let viewModel = SearchUserListViewModel(
            didChangeKeyword: searchBar.rx.text.orEmpty.asDriver(),
            dependency: .init(searchUserUseCase: SearchUserUseCaseImpl.build()))

        return viewModel
    }

    private func setupObservable() {
        viewModel.users
            .drive(onNext: { [weak self] (users) in
                self?.users = users
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
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
        let cell = tableView.dequeueReusableCell(UserListCell.self, for: indexPath)
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user = users[indexPath.row]
        user.isFavorite.toggle()
        users[indexPath.row] = user
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
