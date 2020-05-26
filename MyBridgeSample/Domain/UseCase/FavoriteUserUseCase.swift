//
//  FavoriteUserUseCase.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - FavoriteUserUseCaseImple

protocol FavoriteUserUseCase {
    /// 指定された名前でユーザを検索します。
    /// - parameter name: 検索したい名前
    /// - returns: ユーザ一覧の`Single`
    func search(name: String) -> Single<[User]>

    /// 指定されたユーザをお気に入りに追加します。
    /// - parameter user: ユーザ
    /// - returns: お気に入りの状態(true) or error
    func add(user: User) -> Single<Bool>

    /// 指定されたユーザIDのユーザをお気に入りから削除します。
    /// - parameter id: ユーザID
    /// - returns: お気に入りの状態(false) or error
    func remove(id: Int) -> Single<Bool>
}


// MARK: - FavoriteUserRepository

protocol FavoriteUserRepository {
    /// 指定されたユーザIDでユーザを検索します。
    /// - parameter id: 検索したいユーザID
    /// - returns: 該当したユーザ
    func fetchBy(id: Int) -> User?

    /// 指定された名前で検索します。
    /// - parameter likeName: 検索したい名前
    /// - returns: ユーザ一覧の`Single`
    func fetchBy(likeName name: String) -> Single<[User]>

    /// 指定されたユーザをお気に入りに追加します。
    /// - parameter user: ユーザ
    /// - returns: お気に入りの状態(true) or error
    func add(user: User) -> Single<Bool>

    /// 指定されたユーザIDのユーザをお気に入りから削除します。
    /// - parameter id: ユーザID
    /// - returns: お気に入りの状態(false) or error
    func remove(id: Int) -> Single<Bool>
}


// MARK: - FavoriteUserUseCaseImpl

final class FavoriteUserUseCaseImpl: FavoriteUserUseCase {
    private let repository: FavoriteUserRepository

    init(repository: FavoriteUserRepository) {
        self.repository = repository
    }

    func search(name: String) -> Single<[User]> {
        repository.fetchBy(likeName: name)
    }

    func add(user: User) -> Single<Bool> {
        repository.add(user: user)
    }

    func remove(id: Int) -> Single<Bool> {
        repository.remove(id: id)
    }
}
