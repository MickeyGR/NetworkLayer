//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// The main contract for our network service, defining what it can do.
public protocol NetworkService {
    func request<T: Decodable>(endpoint: some Endpoint) async throws -> T
}
