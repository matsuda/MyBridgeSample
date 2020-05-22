//
//  GitHubRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit
import WebLinking

// MARK: - GitHubRequest

public protocol GitHubRequest: Request {}

extension GitHubRequest {
    public var baseURL: URL { URL(string: "https://api.github.com")! }
    public var method: HTTPMethod { .get }

    public var headerFields: [String: String] {
        var dict: [String: String] = [
            "Accept": "application/vnd.github.v3+json",
        ]
        if let token = GitHubConfig.shared.token, !token.isEmpty {
            dict["Authorization"] = "token \(token)"
        }
        return dict
    }

    public var dataParser: DataParser {
        return DecodableDataParser()
    }
}


// MARK: - GitHubRequest

extension GitHubRequest where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
//        #if DEBUG
        #if false
        dumpResponse(with: data)
        #endif

        return try JSONDecoder().decode(Response.self, from: data)
    }
}


// MARK: - PaginationRequest

extension PaginationRequest {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
//        #if DEBUG
        #if false
        dumpResponse(with: data)
        #endif

//        print("====================================")
//        print("==========   headers    ============")
//        print("====================================")
//        urlResponse.allHeaderFields.forEach { print($0) }
//        print("====================================")

        let elements = try JSONDecoder().decode(Response.Element.self, from: data)
        let nextURI = urlResponse.findLink(relation: "next")?.uri
        print("nextURI >>>>>>>", nextURI as Any)
        let queryItems = nextURI.flatMap(URLComponents.init)?.queryItems
        let nextPage = queryItems?
            .filter { $0.name == nextPageKey }
            .compactMap { $0.value }
            .compactMap { Int($0) }
            .first
        return Response(elements: elements, nextPage: nextPage)
    }
}


// MARK: - Request custom functions

extension Request {
    fileprivate func dumpResponse(with data: Data) {
        guard let jsonString = String(data: data, encoding: .utf8) else { return }

        print("======================================")
        print(jsonString)
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            print("documentDirectory >>>>>", path)
            let filename = (self.path as NSString).lastPathComponent
            let file = (path as NSString).appendingPathComponent("\(filename).json")
            do {
                try jsonString.write(toFile: file, atomically: false, encoding: .utf8)
            } catch {
                print("error >>>", error)
            }
        }
        print("======================================")
    }
}


// MARK: -

#if DEBUG
extension GitHubRequest {
    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        print("request path >>>>>", urlRequest.url?.absoluteString ?? "")
        return urlRequest
    }
}
#endif
