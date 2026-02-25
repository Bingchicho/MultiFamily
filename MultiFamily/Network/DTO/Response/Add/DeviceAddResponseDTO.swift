//
//  DeviceAddResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//


//
// MARK: - Response
//

struct DeviceAddResponseDTO: Decodable {
    let applicationID: String
    let thingName: String
    let bt: DeviceAddBTResponseDTO
    let remotePinCode: String
    let installationNotComplete: Bool?
    let clientToken: String
}

/// response 裡面 bt 的 uuid key 叫 "bt"（很怪但你提供就是這樣）
/// 用 CodingKeys 對應成 uuid
struct DeviceAddBTResponseDTO: Decodable {
    let uuid: String
    let key: String
    let token: String
    let iv: String

    enum CodingKeys: String, CodingKey {
        case uuid
        case key
        case token
        case iv
    }
}
