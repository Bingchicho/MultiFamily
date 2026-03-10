//
//  PermissionDeleteRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct PermissionDeleteRequestDTO: Encodable {

    let applicationID: String
    let thingName: String
    let user: UserIdentityDTO
    let clientToken: String

    struct UserIdentityDTO: Encodable {
        let identityID: String
    }
}
