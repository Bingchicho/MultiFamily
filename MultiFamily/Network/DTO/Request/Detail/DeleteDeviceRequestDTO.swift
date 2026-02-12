//
//  DeleteDeviceRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//


import Foundation

struct DeleteDeviceRequestDTO: Encodable {

    let applicationID: String
    let thingName: String
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case thingName
        case clientToken
    }
}
