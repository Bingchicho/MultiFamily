//
//  UserResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

struct UserResponseDTO: Decodable {

    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let attribute: AttributeDTO
    let identityID: String
    let email: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case attribute
        case identityID
        case email
        case clientToken
    }
}

extension UserResponseDTO {
    func toDomain(now: Date = Date()) -> UserToken {
        UserToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: now.addingTimeInterval(TimeInterval(expiresIn))
        )
    }
}
