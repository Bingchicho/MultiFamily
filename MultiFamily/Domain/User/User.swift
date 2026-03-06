//
//  UserList.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

import Foundation
struct User: Equatable {

    let id: String
    let name: String
    let email: String
    let role: UserRole
    let group: String

}


struct InviteUser: Equatable {

    let inviteCode: String
    let email: String
    let role: UserRole
    let createAt: Double
    let siteID: String
}


enum UserListResult {
    case success(users: [User], inviteUsers: [InviteUser])
    case failure(String)
    case optionSuccess
}


