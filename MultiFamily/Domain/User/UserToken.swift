//
//  User.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

struct UserToken {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    var isExpired: Bool {
        Date() >= expiresAt
    }
}
