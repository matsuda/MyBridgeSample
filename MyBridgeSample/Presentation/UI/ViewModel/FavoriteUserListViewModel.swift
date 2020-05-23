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
import RealmSwift

final class FavoriteUserListViewModel {
    enum UpdateState {
        case initial(isEmpty: Bool)
        case update(isEmpty: Bool, deletions: [Int], insertiona: [Int], modifications: [Int])
        case error(Error)
    }

    var updateState: Observable<UpdateState> {
        _updateState.asObservable()
    }
    private let _updateState: PublishRelay<UpdateState> = .init()
    private let useCase: FavoriteUserUseCase
//    var users: Driver<[User]>
//    private let results: Results<FavoriteUser>
    private var notificationToken: NotificationToken?
    var users: [User] = []

    init(realm: Realm,
         useCase: FavoriteUserUseCase) {
        self.useCase = useCase

        let results = realm.objects(FavoriteUser.self).orderd()

        notificationToken = results.observe({ [weak self] (change: RealmCollectionChange) in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                self._updateState.accept(.error(error))
            case .initial(let results):
                self.users = results.map { User(favoriteUser: $0) }
                self._updateState.accept(.initial(isEmpty: results.isEmpty))
            case .update(let results, let deletions, let insertions, let modifications):
                self.users = results.map { User(favoriteUser: $0) }
                self._updateState.accept(.update(isEmpty: results.isEmpty,
                                                 deletions: deletions,
                                                 insertiona: insertions,
                                                 modifications: modifications))
            }
        })
    }

    deinit {
        notificationToken?.invalidate()
    }
}


extension FavoriteUserListViewModel {
    func like(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        useCase.remove(id: user.id)
    }
}
