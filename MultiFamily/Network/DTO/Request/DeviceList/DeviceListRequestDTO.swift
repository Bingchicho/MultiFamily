//
//  DeviceListRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

struct DeviceListRequestDTO: Codable {

    let applicationID: String
    let siteID: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case siteID
        case clientToken
    }
}
