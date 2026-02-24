//
//  Untitled.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

// MARK: - Provision

enum ActiveModeDTO: String, Codable {
    case ble
    case wifi
}

struct ProvisionRequestDTO: Encodable {
    let applicationID: String
    let siteID: String
    let activeMode: ActiveModeDTO
    let model: String
    let clientToken: String
}


