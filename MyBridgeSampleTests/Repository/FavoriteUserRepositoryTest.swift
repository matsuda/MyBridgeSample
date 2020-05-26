//
//  FavoriteUserRepositoryTest.swift
//  MyBridgeSampleTests
//
//  Created by Kosuke Matsuda on 2020/05/26.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import XCTest
@testable import MyBridgeSample
import RxSwift
import RxTest
import RealmSwift

class FavoriteUserRepositoryTest: XCTestCase {

    private lazy var realm: Realm! = self.prepareRealm(identifier: "FavoriteUserRepositoryTest")
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        realm.refresh()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try! realm.write {
            realm.deleteAll()
        }
        disposeBag = nil
    }

    func testFetchById() throws {
        // Given
        prepareFavoriteUsers(realm: realm)

        let repository = FavoriteUserRepositoryImpl(realm: realm)

        // When
        let user = repository.fetchBy(id: 145676)

        // Then
        XCTAssert(user?.id == 145676)
        XCTAssert(user?.name == "tomayac")
        XCTAssert(user?.avatarUrl == "https://avatars3.githubusercontent.com/u/145676?v=4")
        XCTAssert(user?.isFavorite == true)
    }

    func testFetchByIdNotFound() throws {
        // Given
        prepareFavoriteUsers(realm: realm)

        let repository = FavoriteUserRepositoryImpl(realm: realm)

        // When
        let user = repository.fetchBy(id: 123)

        // Then
        XCTAssert(user == nil)
    }

    func testFetchLikeName() throws {
        // Given
        prepareFavoriteUsers(realm: realm)

        let repository = FavoriteUserRepositoryImpl(realm: realm)

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([User].self)

        // When
        repository.fetchBy(likeName: "tom")
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Then
        XCTAssert(observer.events[0].value.element!.count == 4)

        XCTAssert(observer.events[0].value.element![0].id == 748)
        XCTAssert(observer.events[0].value.element![0].name == "tom")
        XCTAssert(observer.events[0].value.element![0].avatarUrl == "https://avatars1.githubusercontent.com/u/748?v=4")
        XCTAssert(observer.events[0].value.element![0].isFavorite == true)

        XCTAssert(observer.events[0].value.element![1].name == "tomayac")
        XCTAssert(observer.events[0].value.element![2].name == "tomnomnom")

        XCTAssert(observer.events[0].value.element![3].id == 3192)
        XCTAssert(observer.events[0].value.element![3].name == "tomstuart")
        XCTAssert(observer.events[0].value.element![3].avatarUrl == "https://avatars2.githubusercontent.com/u/3192?v=4")
        XCTAssert(observer.events[0].value.element![3].isFavorite == true)
    }

    func testAdd() throws {
        // Given
        let userJSON = sampleUserJSONString()
        let githubUser = try! decodeJSONString(GitHubUser.self, from: userJSON)
        let user = User(gitHubUser: githubUser)

        let repository = FavoriteUserRepositoryImpl(realm: realm)

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let beforeObserver = scheduler.createObserver([User].self)
        let afterObserver = scheduler.createObserver([User].self)

        repository.fetchBy(likeName: user.name)
            .asObservable()
            .bind(to: beforeObserver)
            .disposed(by: disposeBag)
        XCTAssert(beforeObserver.events[0].value.element!.isEmpty == true)

        // When
        repository.add(user: user)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Then
        XCTAssert(observer.events[0].value.element! == true)

        repository.fetchBy(likeName: user.name)
            .asObservable()
            .bind(to: afterObserver)
            .disposed(by: disposeBag)
        XCTAssert(afterObserver.events[0].value.element!.isEmpty == false)
    }

    func testRemove() throws {
        // Given
        prepareFavoriteUsers(realm: realm)

        let repository = FavoriteUserRepositoryImpl(realm: realm)

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let beforeObserver = scheduler.createObserver([User].self)
        let afterObserver = scheduler.createObserver([User].self)

        let id = 145676
        let name = "tomayac"

        repository.fetchBy(likeName: name)
            .asObservable()
            .bind(to: beforeObserver)
            .disposed(by: disposeBag)
        XCTAssert(beforeObserver.events[0].value.element!.isEmpty == false)

        // When
        repository.remove(id: id)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Then
        XCTAssert(observer.events[0].value.element! == false)

        repository.fetchBy(likeName: name)
            .asObservable()
            .bind(to: afterObserver)
            .disposed(by: disposeBag)
        XCTAssert(afterObserver.events[0].value.element!.isEmpty == true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
