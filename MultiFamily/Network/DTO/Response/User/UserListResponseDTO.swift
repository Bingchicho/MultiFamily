//
//  UserListResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

struct UserListResponseDTO: Decodable {

    let users: [UserDTO]
    let inviteUsers: [InviteUserDTO]
    let clientToken: String

}

struct UserDTO: Decodable {

    let identityID: String
    let email: String?
    let attribute: UserAttributeDTO

}

struct UserAttributeDTO: Decodable {

    let preferredUsername: String?
    let permission: [UserPermissionDTO]?
    let debugLog: Bool?
    let verifyRequired: VerifyRequiredDTO?

    enum CodingKeys: String, CodingKey {
        case preferredUsername = "PreferredUsername"
        case permission
        case debugLog = "DebugLog"
        case verifyRequired = "VerifyRequired"
    }

}

struct UserPermissionDTO: Decodable {

    let group: String
    let userRole: String

}


struct VerifyRequiredDTO: Decodable {

    let accessCheck: String?
    let email: String?
    let replacePwd: String?
    let resetPwd: String?

    enum CodingKeys: String, CodingKey {
        case accessCheck = "ACCESS_CHECK"
        case email = "EMAIL"
        case replacePwd = "REPLACE_PWD"
        case resetPwd = "RESET_PWD"
    }

}

struct InviteUserDTO: Decodable {

    let applicationID: String
    let inviteCode: String
    let from: String
    let email: String
    let permission: [InvitePermissionDTO]
    let expirationTime: Int
    let createAt: Int

}


struct InvitePermissionDTO: Decodable {

    let siteID: String
    let userRole: String

}

// MARK: - Domain Mapping

extension UserListResponseDTO {

    func toDomain() -> (users: [User], inviteUsers: [InviteUser]) {
        (
            users: users.map { $0.toDomain() },
            inviteUsers: inviteUsers.map { $0.toDomain() }
        )
    }
}

extension UserDTO {

    func toDomain() -> User {

        let name = attribute.preferredUsername ?? ""
        let role = attribute.permission?.first?.userRole ?? "unknown"

        return User(
            id: identityID,
            name: name,
            email: email ?? "",
            role: role
        )
    }
}

extension InviteUserDTO {

    func toDomain() -> InviteUser {

        let role = permission.first?.userRole ?? "unknown"

        return InviteUser(
            inviteCode: inviteCode,
            email: email,
            role: role,
        )
    }
}
