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
import RealmSwift
import APIKit

final class SearchUserListViewController: UIViewController, TabPageContentViewControllerType {

    // UIs
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private lazy var viewModel: SearchUserListViewModel = createViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - TabPageContentViewControllerType
    var tabPageContentScrollView: UIScrollView? {
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        prepareTabPage()
        setupObservable()
    }
}


// MARK: - private

extension SearchUserListViewController {
    private func createViewModel() -> SearchUserListViewModel {
        let realm = try! userRealm()
        let repository = SearchUserRepositoryImpl(session: .shared)
        let favoriteRepository = FavoriteUserRepositoryImpl(realm: realm)
        let useCase = SearchUserUseCaseImpl(
            repository: repository,
            favoriteUserRepository: favoriteRepository
        )
        return SearchUserListViewModel(
            didChangeKeyword: searchBar.rx.text.orEmpty.asDriver(),
            useCase: useCase
        )
    }

    private func prepareTableView() {
        tableView.registerNib(UserListCell.self)
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
}


// MARK: - UITableViewDataSource

extension SearchUserListViewController: UITableViewDataSource {
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

extension SearchUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.like(at: indexPath)
    }
}
