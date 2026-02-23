//
//  RegistryUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

struct RegistryRequestDTO: Encodable {
    let applicationID: String
    let thingName: String
    let clientToken: String
}
