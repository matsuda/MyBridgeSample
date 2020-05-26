//
//  FavoriteUserListViewModel.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteUserListViewModel {
    /// ユーザ名のイニシャル
    private(set) var nameInitials: [String] = []
    /// イニシャル毎のユーザ一覧
    private(set) var userList: [String: [User]] = [:]

    /// ユーザ一覧取得結果
    var updateState: Driver<ListUpdateState> {
        _updateState.asDriver(onErrorDriveWith: .empty())
    }
    private let _updateState: PublishRelay<ListUpdateState> = .init()

    private let useCase: FavoriteUserUseCase
    private let appStore: ApplicationStore
    /// 検索キーワード（名前）。再検索で利用
    private var keyword: String?
    private let disposeBag = DisposeBag()

    init(useCase: FavoriteUserUseCase,
         appStore: ApplicationStore = .shared,
         didChangeKeyword: Driver<String>) {

        self.useCase = useCase
        self.appStore = appStore

        let refresh: PublishRelay<String> = .init()

        let fixKeyword = didChangeKeyword.skip(1)
            .debounce(.microseconds(300))
            .distinctUntilChanged()

        Driver.merge(fixKeyword, refresh.asDriver(onErrorDriveWith: .empty()))
            .flatMapLatest({ [weak self] keyword in
                return useCase.search(name: keyword)
                    .asObservable()
                    .do(onNext: { (_) in
                        self?.keyword = keyword
                    })
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            })
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

                if isLike {
                    if let keyword = self.keyword {
                        refresh.accept(keyword)
                    }
                } else {
                    if let section = self.nameInitials.firstIndex(of: ini),
                        var users = self.userList[ini],
                        let row = users.firstIndex(where: { $0 == user }) {
                        users.remove(at: row)
                        self.userList[ini] = users
                        self._updateState.accept(.update(isEmpty: self.userList.isEmpty,
                                                         deletions: [IndexPath(row: row, section: section)],
                                                         insertiona: [],
                                                         modifications: []))
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    /// 指定されたユーザをお気に入りから削除します。
    /// - parameter indexPath: 選択されたユーザの`IndexPath`
    func like(at indexPath: IndexPath) {
        let ini = nameInitials[indexPath.section]
        let user = userList[ini]![indexPath.row]
        useCase.remove(id: user.id)
            .subscribe(onSuccess: { [weak self] (isFavorite) in
                self?.appStore.didChangeFavorite.onNext((user, isFavorite))
            })
            .disposed(by: disposeBag)
    }
}
