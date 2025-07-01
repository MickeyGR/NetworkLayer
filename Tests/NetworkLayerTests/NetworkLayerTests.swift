import XCTest

@testable import NetworkLayer

final class NetworkLayerTests: XCTestCase {

    var sut: NetworkService!

    // MARK: - Mock Data For Unit Tests

    struct MockPost: Codable, Equatable {
        let id: Int
        let title: String
    }

    struct EmptyError: Codable, Error {}

    struct GetMockPostsEndpoint: Endpoint {
        typealias ErrorModel = EmptyError
        var baseURL: String = "https://mock.api.com"
        var path: String = "/posts"
        var method: HTTPMethod = .get
    }

    // MARK: - Test Lifecycle

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Unit Tests

    func test_request_whenSuccessful_shouldReturnDecodedObject() async throws {
        // Arrange
        let expectedPosts = [MockPost(id: 1, title: "Test Post")]
        let mockData = try JSONEncoder().encode(expectedPosts)
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.com/posts")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let mockSession = URLSessionMock()
        mockSession.mockData = mockData
        mockSession.mockResponse = mockResponse

        sut = URLSessionNetworkService(session: mockSession)

        // Act
        let result: [MockPost] = try await sut.request(
            endpoint: GetMockPostsEndpoint()
        )

        // Assert
        XCTAssertEqual(result, expectedPosts)
    }

    func test_request_whenResponseIsInvalid_shouldThrowInvalidResponseError()
        async
    {
        // Arrange
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.com/posts")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        let mockSession = URLSessionMock()
        mockSession.mockResponse = mockResponse
        mockSession.mockData = Data()

        sut = URLSessionNetworkService(session: mockSession)

        // Act & Assert
        do {
            let _: [MockPost] = try await sut.request(
                endpoint: GetMockPostsEndpoint()
            )
            XCTFail(
                "Se esperaba que la función lanzara un error, pero no lo hizo."
            )
        } catch {
            if case .invalidResponse = error as? NetworkError {
                // correct
            } else {
                XCTFail(
                    "Se esperaba NetworkError.invalidResponse pero se recibió \(error)"
                )
            }
        }
    }

    func test_request_whenDecodingFails_shouldThrowDecodingError() async {
        // Arrange
        let malformedData = Data("{\"id\": 1}".utf8)
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.com/posts")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let mockSession = URLSessionMock()
        mockSession.mockData = malformedData
        mockSession.mockResponse = mockResponse

        sut = URLSessionNetworkService(session: mockSession)

        // Act & Assert
        do {
            let _: [MockPost] = try await sut.request(
                endpoint: GetMockPostsEndpoint()
            )
            XCTFail("Se esperaba un error de decodificación.")
        } catch {
            guard case .decodingFailed = error as? NetworkError else {
                XCTFail("El error no fue .decodingFailed. Fue: \(error)")
                return
            }
            // correct
        }
    }

    // MARK: - Integration Tests

    func test_fetchRealDigimon_shouldSucceed() async {
        // Arrange
        let networkService = URLSessionNetworkService()
        let digimonEndpoint = DigimonEndpoint.getDigimon(id: 5)

        // Act
        do {
            let birdramon: Digimon = try await networkService.request(
                endpoint: digimonEndpoint
            )

            // Assert
            print("✅ Éxito al obtener Digimon real: \(birdramon.name)")
            XCTAssertEqual(birdramon.name, "Birdramon")

        } catch {
            XCTFail("La solicitud al API de Digimon falló con error: \(error)")
        }
    }

    func test_request_whenDigimonNotFound_shouldThrowApiErrorWithMessage() async
    {
        // Arrange
        let networkService = URLSessionNetworkService()
        let invalidEndpoint = DigimonEndpoint.getDigimon(id: 9999)

        // Act & Assert
        do {
            let _: Digimon = try await networkService.request(
                endpoint: invalidEndpoint
            )
            XCTFail("Se esperaba un ApiError, pero la solicitud tuvo éxito.")
        } catch let error as ApiError {
            print(
                "✅ Éxito al recibir error esperado del API: \(error.localizedDescription)"
            )
            XCTAssertEqual(error.localizedDescription, "Digimon not found")
        } catch {
            XCTFail("Se esperaba un ApiError, pero se recibió: \(error)")
        }
    }
}
