//
//  InviteUserRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

enum DeviceRoleDTO: String, Encodable {
    case sync = "Sync"
    case unlock = "Unlock"
    case firmware = "Firmware"
    case residential = "Residential"
}


struct InviteUserRequestDTO: Encodable {

    let applicationID: String
    let email: String
    let permission: [InviteuserPermission]
    let clientToken: String
    
}

struct InviteuserPermission: Encodable {
    let siteID: String
        let userRole: String
        let devices: [InviteuserPermissionDevices]? // Optional
}

struct InviteuserPermissionDevices: Encodable {
    let thingName: String?    // Optional
    let deviceRole: DeviceRoleDTO?   // Optional
}
