//
//  FavoriteUserListViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import RxSwift

final class FavoriteUserListViewController: UIViewController {

    // UIs
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private lazy var viewModel: FavoriteUserListViewModel = createViewModel()
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

extension FavoriteUserListViewController {
    private func prepareTableView() {
        tableView.registerNib(UserListCell.self)
    }

    private func createViewModel() -> FavoriteUserListViewModel {
        let realm = try! userRealm()
        let repository = FavoriteUserRepositoryImpl(realm: realm)
        let usecase = FavoriteUserUseCaseImpl(repository: repository)
        return FavoriteUserListViewModel(
            realm: realm,
            dependency: FavoriteUserListViewModel.Dependency(favoriteUserUseCase: usecase)
        )
    }

    private func setupObservable() {
        viewModel.updateState
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .error(_):
                    break
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertiona, let modifications):
                    self.tableView.beginUpdates()
                    let dels = deletions.map { IndexPath(row: $0, section: 0) }
                    let ins = insertiona.map { IndexPath(row: $0, section: 0) }
                    let mods = modifications.map { IndexPath(row: $0, section: 0) }
                    self.tableView.deleteRows(at: dels, with: .automatic)
                    self.tableView.insertRows(at: ins, with: .automatic)
                    self.tableView.reloadRows(at: mods, with: .automatic)
                    self.tableView.endUpdates()
                }
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

extension FavoriteUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserListCell.self, for: indexPath)
        let user = viewModel.users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension FavoriteUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.like(at: indexPath)
    }
}
