// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// A collection of convenient type aliases for the NetworkLayer library.
/// This provides a simplified entry point for common types.
public enum NetworkLayer {
    
    /// The default, concrete implementation of the `NetworkService` protocol.
    /// Usage: `let service = NetworkLayer.Service()`
    public typealias Service = URLSessionNetworkService

    /// The primary error type for general network failures.
    /// Usage: `catch let error as NetworkLayer.GeneralError`
    public typealias GeneralError = NetworkError
}
