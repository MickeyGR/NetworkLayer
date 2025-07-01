//
//  URLSessionProtocol.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// A protocol for URLSessionDataTask, to allow mocking.
public protocol URLSessionDataTaskProtocol {
    func resume()
}

// A protocol for URLSession, to allow mocking.
public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) ->
            Void
    ) -> URLSessionDataTaskProtocol
}

// Classes to our protocols.
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) ->
            Void
    ) -> URLSessionDataTaskProtocol {

        return self.dataTask(
            with: request,
            completionHandler: completionHandler
        ) as URLSessionDataTask
    }
}
