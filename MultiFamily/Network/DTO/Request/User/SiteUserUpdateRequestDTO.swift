
//
//  SiteUserUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//
import Foundation
struct SiteUserUpdateRequestDTO: Encodable {

    let applicationID: String
    let siteID: String
    let userID: String
    let userRole: SiteUserRoleDTO
    let clientToken: String

}

enum SiteUserRoleDTO: String, Codable {
    case admin = "Admin"
    case manager = "Manager"
    case user = "User"
}
