//
//  URLSessionMock.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

@testable import NetworkLayer

// A simple mock that conforms to our Task protocol.
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) { self.closure = closure }

    func resume() {
        closure()
    }
}

class URLSessionMock: URLSessionProtocol {
    // Properties to hold the mock data we want to simulate.
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    // This method overrides the real dataTask to return our mock data immediately.
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        let data = self.mockData
        let response = self.mockResponse
        let error = self.mockError

        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}
