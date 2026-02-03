//
//  RegisterRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import Foundation

struct RegisterRequestDTO: Encodable {

    let applicationID: String
    let clientToken: String
    let attribute: AttributeDTO
    let login: LoginPayloadDTO
    let inviteCode: String?

    enum CodingKeys: String, CodingKey {
        case applicationID
        case clientToken
        case attribute
        case login
        case inviteCode
    }
}
