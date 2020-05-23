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
    struct Dependency {
        let searchUserUseCase: SearchUserUseCase
    }

    private let searchUserUseCase: SearchUserUseCase
    var users: Driver<[User]>

    init(didChangeKeyword: Driver<String>,
         dependency: Dependency) {

        let searchUserUseCase = dependency.searchUserUseCase
        self.searchUserUseCase = searchUserUseCase

        self.users = didChangeKeyword.skip(1)
            .debounce(.microseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { keyword in
                searchUserUseCase
                    .search(keyword: keyword, page: nil)
                    .asObservable()
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
        }
    }
}
