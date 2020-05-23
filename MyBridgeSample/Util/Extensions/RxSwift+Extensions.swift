//
//  RxSwift+Extensions.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 `RxSwift`と`RxCocoa`の拡張
 */

// MARK: - ObservableType

extension ObservableType {
    /// 値を`Void`に変換します。
    public func void() -> Observable<Void> {
        return map { (_) in }
    }

    /// 値を`true`に変換します。
    public func `true`() -> Observable<Bool> {
        return map { _ in true }
    }

    /// 値を`false`に変換します。
    public func `false`() -> Observable<Bool> {
        return map { _ in false }
    }
}

extension ObservableType where Self.Element == Bool {
    /// 値が`true`のものだけフィルタします。
    public func onlyTrue() -> Observable<Bool> {
        return filter { $0 }
    }

    /// 値が`false`のものだけフィルタします。
    public func onlyFalse() -> Observable<Bool> {
        return filter { !$0 }
    }
}


// MARK: - SharedSequenceConvertibleType

extension SharedSequenceConvertibleType {
    /// 値を`Void`に変換します。
    public func void() -> SharedSequence<SharingStrategy, Void> {
        return map { (_) in }
    }

    /// 値を`true`に変換します。
    public func `true`() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in true }
    }

    /// 値を`false`に変換します。
    public func `false`() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in false }
    }
}

extension SharedSequenceConvertibleType where Self.Element == Bool {
    /// 値が`true`のものだけフィルタします。
    public func onlyTrue() -> SharedSequence<SharingStrategy, Bool> {
        return filter { $0 }
    }

    /// 値が`false`のものだけフィルタします。
    public func onlyFalse() -> SharedSequence<SharingStrategy, Bool> {
        return filter { !$0 }
    }
}


// MARK: - Reactive

// UIViewController
extension Reactive where Base: UIViewController {
    /// `viewWillAppear`をObservableに変換します
    public var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(base.viewWillAppear(_:)))
            .void()
            .share(replay: 1)
    }

    /// `viewDidAppear`をObservableに変換します
    public var viewDidAppear: Observable<Void> {
        return methodInvoked(#selector(base.viewDidAppear(_:)))
            .void()
            .share(replay: 1)
    }

    /// `viewWillDisappear`をObservableに変換します
    public var viewWillDisappear: Observable<Void> {
        return methodInvoked(#selector(base.viewWillDisappear(_:)))
            .void()
            .share(replay: 1)
    }

    /// `viewDidDisappear`をObservableに変換します
    public var viewDidDisappear: Observable<Void> {
        return methodInvoked(#selector(base.viewDidDisappear(_:)))
            .void()
            .share(replay: 1)
    }
}
