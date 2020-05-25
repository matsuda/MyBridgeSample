//
//  SearchUserRepositoryMock.swift
//  MyBridgeSampleTests
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
@testable import MyBridgeSample
import RxSwift

final class SearchUserRepositoryMock: SearchUserRepository {
    enum APIError: Error {
        case loadError
    }

    func search(keyword: String, page: Int?) -> Single<[GitHubUser]> {
        Single<[GitHubUser]>.create { (observer) -> Disposable in
            do {
                let userList = try self.loadData()
                observer(.success(userList.users))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    private func loadData() throws -> GitHubUserList {
        guard let path = Bundle.main.path(forResource: "users", ofType: "json") else {
            throw APIError.loadError
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let userList = try JSONDecoder().decode(GitHubUserList.self, from: data)
            return userList
        } catch {
            throw error
        }
    }
}
