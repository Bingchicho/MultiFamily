//
//  Site.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import Foundation
public enum siteUserRole: Equatable {
    case admin
    case manager
    case user
    case unknown
}

struct Site: Equatable, Decodable {
    let id: String
    let name: String
    let userRole: String

    var role: siteUserRole {
        switch userRole
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
