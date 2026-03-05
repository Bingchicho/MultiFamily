//
//  UserList.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

import Foundation
struct User {

    let id: String
    let name: String
    let email: String
    let role: String
    
    var roleValue: siteUserRole {
        switch role
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() {
        case "admin":
            return .admin
        case "manager":
            return .manager
        case "user":
            return .user
        default:
            return .unknown
        }
    }
}


struct InviteUser {

    let inviteCode: String
    let email: String
    let role: String
    
    var roleValue: siteUserRole {
        switch role
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() {
        case "admin":
            return .admin
        case "manager":
            return .manager
        case "user":
            return .user
        default:
            return .unknown
        }
    }
}


struct UserListResult {

    let users: [User]
    let inviteUsers: [InviteUser]

}
