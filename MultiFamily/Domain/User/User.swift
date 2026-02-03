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
    case locked(until: Date)
}

enum LoginError: Error, Equatable {
    case invalidCredentials
    case network
    case unknown
}

struct UserAttribute {
    let username: String
    let language: Language
    let phone: String?
    let country: String?
    let isDebugEnabled: Bool?
    let permissions: [UserPermission]?
}

struct UserPermission {
    let siteID: String
    let role: UserRole
}

enum UserRole: String {
    case admin = "Admin"
    case manager = "Manager"
    case user = "user"
}

enum Language: String {
    case zhHant = "zhTW"
    case enUS = "enUS"
    case jaJP = "jaJP"

    static func from(apiValue: String) -> Language {
        Language(rawValue: apiValue) ?? .enUS
    }
}
