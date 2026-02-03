//
//  PermissionDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct AttributeDTO: Codable {
    let preferredUsername: String
    let preferredLanguage: String
    let phone: String?
    let country: String?
    let debugLog: Bool?
    let permission: [PermissionDTO]?

    enum CodingKeys: String, CodingKey {
        case preferredUsername = "PreferredUsername"
        case preferredLanguage
        case phone
        case country
        case debugLog = "debug_log"
        case permission
    }
}

struct PermissionDTO: Codable {
    let siteID: String
    let userRole: String
}

extension AttributeDTO {

    func toDomain() -> UserAttribute {
        UserAttribute(
            username: preferredUsername,
            language: Language.from(apiValue: preferredLanguage),
            phone: phone,
            country: country,
            isDebugEnabled: debugLog,
            permissions: permission?.map { $0.toDomain() }
        )
    }
}

extension PermissionDTO {

    func toDomain() -> UserPermission {
        UserPermission(
            siteID: siteID,
            role: UserRole(rawValue: userRole) ?? .user
        )
    }
}
