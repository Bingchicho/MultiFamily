//
//  PermissionResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation

struct PermissionResponseDTO: Decodable {

    let users: [PermissionUserDTO]
    let cards: [PermissionCardDTO]
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case users
        case cards
        case clientToken
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        // backend 可能不回 cards / users，這裡給預設值避免 keyNotFound
        self.users = (try? c.decodeIfPresent([PermissionUserDTO].self, forKey: .users)) ?? []
        self.cards = (try? c.decodeIfPresent([PermissionCardDTO].self, forKey: .cards)) ?? []
        self.clientToken = (try? c.decodeIfPresent(String.self, forKey: .clientToken)) ?? ""
    }
}

struct PermissionUserDTO: Decodable {

    let attribute: PermissionUserAttributeDTO
    let identityID: String
    let email: String?
}

struct PermissionUserAttributeDTO: Decodable {

    let preferredUsername: String?
    let preferredLanguage: String?
    let debugLog: Bool?

    let phone: String?
    let country: String?

    let permission: [PermissionDeviceRoleDTO]?

    let verifyRequired: PermissionVerifyRequiredDTO?

    enum CodingKeys: String, CodingKey {
        case preferredUsername = "PreferredUsername"
        case preferredLanguage
        case debugLog = "DebugLog"
        case phone
        case country
        case permission
        case verifyRequired = "VerifyRequired"
    }
}

struct PermissionDeviceRoleDTO: Decodable {

    let userRole: String

    enum CodingKeys: String, CodingKey {
        case userRole
        case deviceRole
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.userRole = (try? c.decodeIfPresent(String.self, forKey: .userRole))
            ?? (try? c.decodeIfPresent(String.self, forKey: .deviceRole))
            ?? ""
    }
}

struct PermissionVerifyRequiredDTO: Decodable {

    let accessCheck: String?
    let resetPwd: String?
    let email: String?
    let replacePwd: String?

    enum CodingKeys: String, CodingKey {
        case accessCheck = "ACCESS_CHECK"
        case resetPwd = "RESET_PWD"
        case email = "EMAIL"
        case replacePwd = "REPLACE_PWD"
    }
}


struct PermissionCardDTO: Decodable {

    let applicationID: String
    let id: String
    let siteID: String
    let userID: String?
    let activate: Bool
    let cardType: Int

    let startTime: TimeInterval?
    let endTime: TimeInterval?

    let privateDoors: [PermissionDoorDTO]?
    let publicDoors: [PermissionDoorDTO]?

    let name: String
    let nameTokens: [String]?

    let status: Int
    let createAt: TimeInterval?
}

struct PermissionDoorDTO: Decodable {

    let deviceID: UInt16
    let eDaysMask: UInt8
    let startMinute: UInt16
    let endMinute: UInt16
}


extension PermissionUserDTO {

    func toDomain() -> PermissionUser {

        PermissionUser(
            identityID: identityID,
            email: email ?? "",
            name: attribute.preferredUsername ?? "",
            role: attribute.permission?.first?.userRole ?? ""
        )
    }
}

extension PermissionCardDTO {

    func toDomain() -> PermissionCard {

        PermissionCard(
            id: id,
            name: name,
            cardType: cardType,
            startTime: startTime ?? 0,
            endTime: endTime ?? 0,
            activate: activate
        )
    }
}
