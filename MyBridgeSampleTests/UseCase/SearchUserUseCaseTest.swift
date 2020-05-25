//
//  SearchUserUseCaseTest.swift
//  MyBridgeSampleTests
//
//  Created by Kosuke Matsuda on 2020/05/25.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import XCTest
@testable import MyBridgeSample
import RxSwift
import RxTest
import RealmSwift

class SearchUserUseCaseTest: XCTestCase {

    private lazy var realm: Realm! = self.prepareRealm(identifier: "SearchUserUseCaseTest")
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

    func testSearch() throws {
        // Given
        prepareFavoriteUsers(realm: realm) // Realm

        let repository = SearchUserRepositoryMock()
        let favoriteRepository = FavoriteUserRepositoryImpl(realm: realm)
        let useCase = SearchUserUseCaseImpl(
            repository: repository,
            favoriteUserRepository: favoriteRepository
        )

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([User].self)

        // When
        useCase.search(keyword: "mike")
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Then
        XCTAssert(observer.events[0].value.element![0].id == 748)
        XCTAssert(observer.events[0].value.element![0].name == "tom")
        XCTAssert(observer.events[0].value.element![0].avatarUrl == "https://avatars1.githubusercontent.com/u/748?v=4")
        XCTAssert(observer.events[0].value.element![0].isFavorite == true)

        XCTAssert(observer.events[0].value.element![2].id == 32314)
        XCTAssert(observer.events[0].value.element![2].name == "tmcw")
        XCTAssert(observer.events[0].value.element![2].avatarUrl == "https://avatars2.githubusercontent.com/u/32314?v=4")
        XCTAssert(observer.events[0].value.element![2].isFavorite == false)

        XCTAssert(observer.events[0].value.element!.count == 30)

        XCTAssert(observer.events[0].value.element![29].id == 145676)
        XCTAssert(observer.events[0].value.element![29].name == "tomayac")
        XCTAssert(observer.events[0].value.element![29].avatarUrl == "https://avatars3.githubusercontent.com/u/145676?v=4")
        XCTAssert(observer.events[0].value.element![29].isFavorite == true)

        XCTAssert(observer.events[0].value.element![28].id == 160835)
        XCTAssert(observer.events[0].value.element![28].name == "tombh")
        XCTAssert(observer.events[0].value.element![28].avatarUrl == "https://avatars2.githubusercontent.com/u/160835?v=4")
        XCTAssert(observer.events[0].value.element![28].isFavorite == false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
