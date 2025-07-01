//
//  ApiError.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// Represents the structure of the API's error JSON response.
struct ApiError: Codable, Error, LocalizedError {
    let error: Int
    let message: String

    // Provides a user-friendly description for the error.
    var errorDescription: String? {
        return message
    }
}
