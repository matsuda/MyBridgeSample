//
//  SearchUserRepositoryTest.swift
//  MyBridgeSampleTests
//
//  Created by Kosuke Matsuda on 2020/05/26.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import XCTest
@testable import MyBridgeSample
import RxSwift
import RxTest

class SearchUserRepositoryTest: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        disposeBag = nil
    }

    func testSearch() throws {
        // Given
        let mock = WebAPIMock()
        let repository = SearchUserRepositoryImpl(webAPI: mock)

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([GitHubUser].self)

        // When
        repository.search(keyword: "tom")
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(observer.events[0].value.element!.count, 30)

        XCTAssertEqual(observer.events[0].value.element![0].id, 945979)
        XCTAssertEqual(observer.events[0].value.element![0].login, "dribnet")
        XCTAssertEqual(observer.events[0].value.element![0].avatarUrl, "https://avatars3.githubusercontent.com/u/945979?v=4")

        XCTAssertEqual(observer.events[0].value.element![2].id, 83974)
        XCTAssertEqual(observer.events[0].value.element![2].login, "Knio")
        XCTAssertEqual(observer.events[0].value.element![2].avatarUrl, "https://avatars2.githubusercontent.com/u/83974?v=4")

        XCTAssertEqual(observer.events[0].value.element![28].id, 15076665)
        XCTAssertEqual(observer.events[0].value.element![28].login, "tuananhhedspibk")
        XCTAssertEqual(observer.events[0].value.element![28].avatarUrl, "https://avatars0.githubusercontent.com/u/15076665?v=4")

        XCTAssertEqual(observer.events[0].value.element![29].id, 21292)
        XCTAssertEqual(observer.events[0].value.element![29].login, "twilson63")
        XCTAssertEqual(observer.events[0].value.element![29].avatarUrl, "https://avatars3.githubusercontent.com/u/21292?v=4")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
