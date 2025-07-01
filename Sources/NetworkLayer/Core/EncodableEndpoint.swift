//
//  EncodableEndpoint.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

// A protocol for endpoints that need to send an encodable object in their body.
public protocol EncodableEndpoint: Endpoint {
    // The type of the object that will be encoded into the request body.
    associatedtype BodyModel: Encodable

    // The property where the user provides the Swift object to be sent.
    var encodableBody: BodyModel? { get }
}

extension EncodableEndpoint {
    // This default implementation of 'body' automatically encodes the 'encodableBody' property to JSON data.
    public var body: Data? {
        guard let encodableBody = encodableBody else { return nil }
        return try? JSONEncoder().encode(encodableBody)
    }

    public var encodableBody: BodyModel? {
        return nil
    }
}
