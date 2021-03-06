//
//  SearchUserListViewModel.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchUserListViewModel {
    /// ユーザ名のイニシャル
    private(set) var nameInitials: [String] = []
    /// イニシャル毎のユーザ一覧
    private(set) var userList: [String: [User]] = [:]

    /// ユーザ一覧取得結果
    var updateState: Driver<ListUpdateState> {
        _updateState.asDriver(onErrorDriveWith: .empty())
    }
    private let _updateState: PublishRelay<ListUpdateState> = .init()

    /// お気に入り状態の変更
    let didChangeFavorite: Driver<Bool>

    private let useCase: SearchUserUseCase
    private let appStore: ApplicationStore
    private let disposeBag = DisposeBag()

    init(useCase: SearchUserUseCase,
         appStore: ApplicationStore = .shared,
         didChangeKeyword: Driver<String>) {

        self.useCase = useCase
        self.appStore = appStore

        let _didChangeFavorite = PublishRelay<Bool>()
        didChangeFavorite = _didChangeFavorite.asDriver(onErrorDriveWith: .empty())

        didChangeKeyword.skip(1)
            .debounce(.microseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { keyword in
                useCase
                    .search(keyword: keyword, page: nil)
                    .asObservable()
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
        }
        .drive(onNext: { [weak self] (users) in
            guard let self = self else { return }
            self.userList = Dictionary(grouping: users) { $0.initialIndexTitle }
            self.nameInitials = self.userList.keys.sorted()
            self._updateState.accept(.initial(isEmpty: users.isEmpty))
        })
        .disposed(by: disposeBag)

        appStore.didChangeFavorite
            .subscribe(onNext: { [weak self] (change) in
                guard let self = self else { return }

                let user = change.0
                let isLike = change.1
                let ini = user.initialIndexTitle

                if let section = self.nameInitials.firstIndex(of: ini),
                    var users = self.userList[ini],
                    let row = users.firstIndex(where: { $0 == user }) {
                    var user = users[row]
                    user.isFavorite = isLike
                    users[row] = user
                    self.userList[ini] = users
                    self._updateState.accept(.update(isEmpty: self.userList.isEmpty,
                                                     deletions: [],
                                                     insertiona: [],
                                                     modifications: [IndexPath(row: row, section: section)]))
                    _didChangeFavorite.accept(isLike)
                }
            })
            .disposed(by: disposeBag)
    }

    /// 指定されたユーザをお気に入りに追加、削除します。
    /// - parameter indexPath: 選択されたユーザの`IndexPath`
    func like(at indexPath: IndexPath) {
        let ini = nameInitials[indexPath.section]
        let user = userList[ini]![indexPath.row]

        useCase.like(user: user)
            .subscribe(onSuccess: { [weak self] (isFavorite) in
                self?.appStore.didChangeFavorite.onNext((user, isFavorite))
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Array

extension Array where Element: Hashable {
    func uniq() -> [Element] {
        var set: Set<Element> = .init()
        return filter { (elm) -> Bool in
            if set.contains(elm) { return false }
            set.insert(elm)
            return true
        }
    }
}
