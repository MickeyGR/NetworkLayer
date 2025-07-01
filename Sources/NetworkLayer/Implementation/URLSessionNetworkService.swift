//
//  URLSessionNetworkService.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// The main class that implements the NetworkService protocol using URLSession.
public final class URLSessionNetworkService: NetworkService {

    // The session can be a real URLSession or a mock for testing.
    private let session: URLSessionProtocol

    // Uses dependency injection to allow replacing the session during tests.
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func request<E: Endpoint, T: Decodable>(endpoint: E) async throws
        -> T
    {

        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) {
                data,
                response,
                error in

                if let error = error {
                    continuation.resume(
                        throwing: NetworkError.requestFailed(error)
                    )
                    return
                }

                // Ensure we have valid data and an HTTP response.
                guard let data = data,
                    let httpResponse = response as? HTTPURLResponse
                else {
                    continuation.resume(throwing: NetworkError.unknown)
                    return
                }

                if 200..<300 ~= httpResponse.statusCode {
                    // Success case: decode the expected object.
                    do {
                        let decodedObject = try JSONDecoder().decode(
                            T.self,
                            from: data
                        )
                        continuation.resume(returning: decodedObject)
                    } catch {
                        continuation.resume(
                            throwing: NetworkError.decodingFailed(error)
                        )
                    }
                } else {
                    // Error case: try to decode the API's specific error model.
                    do {
                        let apiError = try JSONDecoder().decode(
                            E.ErrorModel.self,
                            from: data
                        )
                        continuation.resume(throwing: apiError)
                    } catch {
                        // If that fails, throw a generic invalid response error.
                        continuation.resume(
                            throwing: NetworkError.invalidResponse
                        )
                    }
                }
            }
            task.resume()
        }
    }
}
