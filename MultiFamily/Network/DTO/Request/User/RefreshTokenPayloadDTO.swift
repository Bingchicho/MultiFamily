//
//  RefreshTokenPayloadDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct RefreshTokenPayloadDTO: Encodable {
    let grantType: String = "refresh_token"
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
    }
}
