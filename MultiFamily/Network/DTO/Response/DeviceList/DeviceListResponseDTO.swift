//
//  DeviceListResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

struct DeviceListResponseDTO: Decodable {

    let devices: [DeviceDTO]
    let clientToken: String
}

struct DeviceDTO: Decodable {

    let applicationID: String
    let thingName: String
    let deviceID: UInt16
    let activeMode: String
    let model: String
    let group: String
    let name: String
    let isResident: Bool
    let deviceRole: String

    let bt: DeviceBTDTO?

    let gateway: Int
    let job: Int
    let ota: Int
}

struct DeviceBTDTO: Decodable {

    let uuid: String
    let key: String
    let token: String
}
