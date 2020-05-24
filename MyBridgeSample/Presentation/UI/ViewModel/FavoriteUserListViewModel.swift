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
    private(set) var users: [User] = []
    var updateState: Observable<ListUpdateState> {
        _updateState.asObservable()
    }
    private let _updateState: PublishRelay<ListUpdateState> = .init()

    private let useCase: FavoriteUserUseCase
    private let appStore: ApplicationStore
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
                self.users = users
                self._updateState.accept(.initial(isEmpty: users.isEmpty))
            })
            .disposed(by: disposeBag)

        appStore.didChangeFavorite
            .subscribe(onNext: { [weak self] (change) in
                guard let self = self else { return }

                let id = change.0
                let isLike = change.1

                if isLike {
                    if let keyword = self.keyword {
                        refresh.accept(keyword)
                    }
                } else {
                    if let index = self.users.firstIndex(where: { $0.id == id }) {
                        self.users.remove(at: index)
                        self._updateState.accept(.update(isEmpty: self.users.isEmpty,
                                                         deletions: [index],
                                                         insertiona: [],
                                                         modifications: []))
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func like(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        useCase.remove(id: user.id)
            .subscribe(onSuccess: { [weak self] (isFavorite) in
                self?.appStore.didChangeFavorite.onNext((user.id, isFavorite))
            })
            .disposed(by: disposeBag)
    }
}
