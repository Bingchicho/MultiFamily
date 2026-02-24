//
//  ProvisionResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

struct ProvisionResponseDTO: Decodable {
    let applicationID: String
    let thingName: String
    let bt: ProvisionBTDTO
    let remotePinCode: String
    let installationNotComplete: Bool
    let clientToken: String
}

struct ProvisionBTDTO: Decodable {
    let uuid: String
    let key: String
    let token: String
    let iv: String
}

