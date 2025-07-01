//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// Enum for handling network layer specific errors.
public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case invalidResponse
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let error):
            return "The request failed: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return
                "Failed to decode the response: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server's response was not valid."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
