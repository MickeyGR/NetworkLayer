//
//  Digimon.swift
//  NetworkLayer
//
//  Created by Mickey Anthony Gudiel Reyes on 30/6/25.
//

import Foundation

struct Digimon: Codable {
    let id: Int
    let name: String
    let images: [DigimonImage]
    let levels: [DigimonLevel]
    let types: [DigimonType]
}

struct DigimonImage: Codable {
    let href: String
}

struct DigimonLevel: Codable {
    let level: String
}

struct DigimonType: Codable {
    let type: String
}
