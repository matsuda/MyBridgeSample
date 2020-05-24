//
//  FavoriteUserListViewController.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/22.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import RxSwift

final class FavoriteUserListViewController: UIViewController, TabPageContentViewControllerType {

    // UIs
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private lazy var viewModel: FavoriteUserListViewModel = createViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - TabPageContentViewControllerType
    var tabPageContentScrollView: UIScrollView? {
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        prepareTabPage()
        prepareSearchBar()
        setupObservable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
}


// MARK: - private

extension FavoriteUserListViewController {
    private func createViewModel() -> FavoriteUserListViewModel {
        let realm = try! userRealm()
        let repository = FavoriteUserRepositoryImpl(realm: realm)
        let useCase = FavoriteUserUseCaseImpl(repository: repository)
        return FavoriteUserListViewModel(
            useCase: useCase,
            didChangeKeyword: searchBar.rx.text.orEmpty.asDriver()
        )
    }

    private func prepareTableView() {
        tableView.registerNib(UserListCell.self)
        tableView.keyboardDismissMode = .onDrag
    }

    private func prepareSearchBar() {
        searchBar.placeholder = "ユーザ名を入力してください"
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
                    self.tableView.deleteRows(at: deletions, with: .automatic)
                    self.tableView.insertRows(at: insertiona, with: .automatic)
                    self.tableView.reloadRows(at: modifications, with: .automatic)
                    self.tableView.endUpdates()
                }
            })
        .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDataSource

extension FavoriteUserListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.nameInitials.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.nameInitials[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inital = viewModel.nameInitials[section]
        return viewModel.userList[inital]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserListCell.self, for: indexPath)
        let inital = viewModel.nameInitials[indexPath.section]
        let users = viewModel.userList[inital]!
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.nameInitials
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}


// MARK: - UITableViewDelegate

extension FavoriteUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.like(at: indexPath)
    }
}
