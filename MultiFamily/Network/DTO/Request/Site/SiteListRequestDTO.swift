//
//  SiteListRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

struct SiteListRequestDTO: Encodable {

    let applicationID: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case clientToken
    }
}
