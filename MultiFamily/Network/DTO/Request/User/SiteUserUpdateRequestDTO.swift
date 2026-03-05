
//
//  SiteUserUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

struct SiteUserUpdateRequestDTO: Encodable {

    let applicationID: String
    let siteID: String
    let userID: String
    let userRole: UserRole
    let clientToken: String

}


