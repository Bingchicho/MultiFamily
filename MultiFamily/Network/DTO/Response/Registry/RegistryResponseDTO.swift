//
//  RegistryResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

struct RegistryResponseDTO: Decodable {

    let applicationID: String
    let uuid: String?
    let siteID: String?
    let thingName: String
    let activeMode: String?
    let deviceID: Int?
    let model: String?
    let name: String?

    let createAt: Int?
    let isResident: Bool?
    let remotePinCode: String?
    let installationNotComplete: Bool?

    let bt: LockBTDTO?
    let attributes: DeviceAttributesDTO?

    let clientToken: String
}



