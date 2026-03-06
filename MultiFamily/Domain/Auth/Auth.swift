//
//  User.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

enum LoginResult: Equatable {
    case success
    case verificationRequired(ticket: String)
    case failure(LoginError)
}

enum LoginError: Error, Equatable {
    case invalidCredentials
    case network
    case unknown
}

struct UserAttribute {
    let username: String
    let language: Language?
    let phone: String?
    let country: String?
    let isDebugEnabled: Bool?
    let permissions: [UserPermission]?
    var identityID: String?
}

struct UserPermission: Codable {
    let siteID: String?
    let userRole: UserRole?
    let group: String?

}

enum UserRole: String, Codable, CaseIterable, Equatable {

    case admin = "Admin"
    case manager = "Manager"
    case user = "User"

}

extension UserRole {

    var title: String {
        switch self {
        case .admin: return L10n.Common.Admin.title
        case .manager: return L10n.Common.Manager.title
        case .user: return L10n.Common.User.title
        }
    }

}

enum Language: String {
    case zhHant = "zhTW"
    case enUS = "enUS"
    case jaJP = "jaJP"

    static func from(apiValue: String?) -> Language {
        guard let apiValue = apiValue else {
            return .enUS
        }
        return Language(rawValue: apiValue) ?? .enUS
    }
}
