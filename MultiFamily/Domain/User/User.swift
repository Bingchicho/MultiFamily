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
    let role: UserRole

}


struct InviteUser {

    let inviteCode: String
    let email: String
    let role: UserRole
    
}


struct UserListResult {

    let users: [User]
    let inviteUsers: [InviteUser]

}
