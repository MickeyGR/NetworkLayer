//
//  Endpoint.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// Defines the supported HTTP methods.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// A blueprint for creating an API request.
public protocol Endpoint {
    // The model to decode if the request returns an error.
    associatedtype ErrorModel: Decodable & Error

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    // A default base URL to avoid repetition.
    public var baseURL: String {
        return "https://api.example.com"
    }

    // By default, no headers are sent.
    public var headers: [String: String]? {
        return nil
    }

    // By default, no body is sent.
    public var body: Data? {
        return nil
    }
}
