//
//  PermissionRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

struct PermissionRequestDTO: Encodable {

    let applicationID: String
    let thingName: String
    let clientToken: String
}
