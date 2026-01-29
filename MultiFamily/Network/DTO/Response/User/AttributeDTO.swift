//
//  PermissionDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct AttributeDTO: Decodable {
    let preferredUsername: String
    let preferredLanguage: String
    let phone: String
    let country: String
    let debugLog: Bool
    let permission: [PermissionDTO]

    enum CodingKeys: String, CodingKey {
        case preferredUsername = "PreferredUsername"
        case preferredLanguage
        case phone
        case country
        case debugLog = "debug_log"
        case permission
    }
}

struct PermissionDTO: Decodable {
    let siteID: String
    let userRole: String
}
