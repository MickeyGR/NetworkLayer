//
//  DigimonEndpoint.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

@testable import NetworkLayer

enum DigimonEndpoint {
    case getDigimon(id: Int)
    case addDigimon(newDigimon: Digimon)
}

extension DigimonEndpoint: EncodableEndpoint {
    typealias ErrorModel = ApiError
    typealias BodyModel = Digimon

    var baseURL: String {
        return "https://digi-api.com"
    }

    var path: String {
        switch self {
        case .getDigimon(let id):
            return "/api/v1/digimon/\(id)"
        case .addDigimon:
            return "/api/v1/digimon"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDigimon:
            return .get
        case .addDigimon:
            return .post
        }
    }

    var headers: [String: String]? {
        switch self {
        case .addDigimon:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }

    // Versión manual
    //    var body: Data? {
    //        switch self {
    //        case .addDigimon(let newDigimon):
    //            // Codificamos el objeto newDigimon a JSON para enviarlo
    //            return try? JSONEncoder().encode(newDigimon)
    //        }
    //    }

    var encodableBody: Digimon? {
        switch self {
        case .addDigimon(let digimon):
            return digimon
        default:
            return nil
        }
    }
}
