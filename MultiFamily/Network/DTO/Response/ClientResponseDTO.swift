//
//  ClientResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

struct ClientResponseDTO: Decodable {

    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case clientToken
    }
}
