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
    var users: Driver<[User]>

    private let useCase: SearchUserUseCase

    init(didChangeKeyword: Driver<String>,
         useCase: SearchUserUseCase) {

        self.useCase = useCase

        self.users = didChangeKeyword.skip(1)
            .debounce(.microseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { keyword in
                useCase
                    .search(keyword: keyword, page: nil)
                    .asObservable()
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
        }
    }
}


extension SearchUserListViewModel {
    func like(user: User) {
        useCase.like(user: user)
    }
}
