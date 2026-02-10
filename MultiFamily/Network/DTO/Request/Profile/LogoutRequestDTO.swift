//
//  LogoutRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

struct LogoutRequestDTO: Encodable {

    let applicationID: String
    let logoutAllDevice: Bool
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case logoutAllDevice
        case clientToken
    }
}
