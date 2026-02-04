//
//  RegisterVerifyRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

struct RegisterVerifyRequestDTO: Encodable {

    let ticket: String
    let code: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case ticket
        case code
        case clientToken
    }
}
