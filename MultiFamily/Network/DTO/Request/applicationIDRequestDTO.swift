//
//  ApplictionIDRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

//
//  DeleteAccountRequestDTO.swift
//  MultiFamily
//

import Foundation

struct applicationIDRequestDTO: Encodable {

    let applicationID: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case clientToken
    }
}
