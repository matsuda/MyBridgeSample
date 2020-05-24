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
    private let disposeBag = DisposeBag()

    init(useCase: FavoriteUserUseCase,
         didChangeKeyword: Driver<String>) {
        self.useCase = useCase

        didChangeKeyword.skip(1)
            .debounce(.microseconds(300))
            .distinctUntilChanged()
            .map({ (keyword) in
                useCase.search(name: keyword)
            })
            .drive(onNext: { [weak self] (users) in
                guard let self = self else { return }
                self.users = users
                self._updateState.accept(.initial(isEmpty: users.isEmpty))
            })
            .disposed(by: disposeBag)
    }

    func like(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        useCase.remove(id: user.id)
    }
}
