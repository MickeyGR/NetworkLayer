//
//  README.md
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 1/7/25.
//

# NetworkLayer

A protocol-oriented Swift library for building type-safe, testable REST API clients with `async/await`.

## Features

* **Protocol-Oriented Design**: Easy to test and mock for reliable unit tests.
* **Modern Concurrency**: Built with `async/await` for clean, modern asynchronous code.
* **Generic**: Can decode any `Codable` model for both success and error responses.
* **Smart Error Handling**: Can decode custom error models directly from API responses.
* **Automatic Encoding**: Automatically encodes `Encodable` objects for request bodies, reducing boilerplate.

## Installation

You can add NetworkLayer to your project using Swift Package Manager.

1.  In Xcode, go to **File > Add Packages...**
2.  Paste the repository URL: `https://github.com/MickeyGR/NetworkLayer.git`
3.  Xcode will show the package product (`NetworkLayer`). Ensure it is selected and that your main app is chosen in the **"Add to Target"** column before clicking **Add Package**.

#### Troubleshooting

If after adding the package you get an error like `No such module 'NetworkLayer'`, it means the library was not linked correctly to your app. To fix it manually:

1.  In the Project Navigator, click on your project's blue icon at the top.
2.  Select your app's **target**.
3.  Go to the **"General"** tab.
4.  Scroll down to the **"Frameworks, Libraries, and Embedded Content"** section.
5.  Click the **`+`** button, select `NetworkLayer` from the list, and click **Add**.

## Usage Example

Here is a real example of how to fetch a "Digimon" from a public API.

#### 1. Define your Models & Endpoint

First, define the Swift models that match the API's JSON response and the endpoint you want to call.

```swift
import NetworkLayer

// Model for the API response
struct Digimon: Codable {
    let id: Int
    let name: String
}

// Model for the API's specific error response
struct ApiError: Codable, Error, LocalizedError {
    let error: Int
    let message: String
    var errorDescription: String? { return message }
}

// Define the specific endpoint
enum DigimonEndpoint {
    case getDigimon(id: Int)
}

extension DigimonEndpoint: Endpoint {
    typealias ErrorModel = ApiError
    
    var baseURL: String { "[https://digi-api.com](https://digi-api.com)" }
    
    var path: String {
        switch self {
        case .getDigimon(let id):
            return "/api/v1/digimon/\(id)"
        }
    }
    
    var method: HTTPMethod { .get }
}
```

#### 2. Make the Request

Create an instance of the service and make the request.

```swift
import NetworkLayer

// Using the typealias for convenience
let networkService = NetworkLayer.Service() 

func fetchDigimon(id: Int) async {
    let endpoint = DigimonEndpoint.getDigimon(id: id)
    do {
        let digimon: Digimon = try await networkService.request(endpoint: endpoint)
        print("✅ Successfully fetched: \(digimon.name)")
    } catch let error as ApiError {
        print("🛑 API Error: \(error.localizedDescription)")
    } catch {
        print("🛑 Network Error: \(error.localizedDescription)")
    }
}

// Example calls
await fetchDigimon(id: 5) // Success
await fetchDigimon(id: 9999) // API Error
```

## Advanced Usage (POST, PUT, DELETE)

Here is how you would define `POST`, `PUT`, and `DELETE` requests using the `EncodableEndpoint` protocol for automatic body encoding.

#### 1. Expand the Endpoint Enum

First, add new cases for the new operations and define a `Payload` struct for the data you want to send.

```swift
struct DigimonPayload: Codable {
    let name: String
    let level: String
}

enum DigimonEndpoint {
    // ... existing cases
    case addDigimon(payload: DigimonPayload)
    case updateDigimon(id: Int, payload: DigimonPayload)
    case deleteDigimon(id: Int)
}
```

#### 2. Update the Endpoint Conformance

Conform to `EncodableEndpoint` and add the logic for the new cases.

```swift
// Conform to EncodableEndpoint to handle request bodies automatically
extension DigimonEndpoint: EncodableEndpoint {
    typealias BodyModel = DigimonPayload
    // ... other properties like baseURL, path, etc.

    var method: HTTPMethod {
        switch self {
        case .getDigimon: .get
        case .addDigimon: .post
        case .updateDigimon: .put
        case .deleteDigimon: .delete
        }
    }

    // You only need to provide the object. The library handles the encoding.
    var encodableBody: DigimonPayload? {
        switch self {
        case .addDigimon(let payload), .updateDigimon(_, let payload):
            return payload
        default:
            return nil
        }
    }
}
```
