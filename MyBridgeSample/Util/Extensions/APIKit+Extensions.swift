//
//  APIKit+Extensions.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

extension Session {
    class func response<T: Request>(request: T, callbackQueue: CallbackQueue? = .main) -> Single<T.Response> {
        return Single.create { (observer) -> Disposable in
            let task = self.send(request, callbackQueue: callbackQueue) { (result) in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }

    func response<T: Request>(request: T, callbackQueue: CallbackQueue? = .main) -> Single<T.Response> {
        return type(of: self).response(request: request, callbackQueue: callbackQueue)
    }
}
