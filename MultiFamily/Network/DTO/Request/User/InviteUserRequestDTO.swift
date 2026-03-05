//
//  InviteUserRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

struct InviteUserRequestDTO: Encodable {

    let applicationID: String
    let email: String
    let permission: [UserPermission]
    let clientToken: String
    
}
