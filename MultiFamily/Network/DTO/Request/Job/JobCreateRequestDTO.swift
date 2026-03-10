//
//  JobCreateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct JobCreateRequestDTO: Encodable {

    let applicationID: String
    let thingName: String
    let siteID: String
    let action: JobActionDTO
    let payload: JobPayloadDTO
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case thingName
        case siteID
        case status
        case action
        case blackList
        case payloadVersion
        case direction
        case lockState
        case clientToken
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(applicationID, forKey: .applicationID)
        try container.encode(thingName, forKey: .thingName)
        try container.encode(siteID, forKey: .siteID)
        try container.encode(action.value, forKey: .action)
        try container.encode(clientToken, forKey: .clientToken)

        switch payload {

        case .blackList(let list):
            try container.encode("wait", forKey: .status)
            try container.encode(list, forKey: .blackList)

        case .direction(let value):
            try container.encode(1, forKey: .payloadVersion)
            try container.encode(value, forKey: .direction)

        case .lockState(let state):
            try container.encode(1, forKey: .payloadVersion)
            try container.encode(state, forKey: .lockState)
        }
    }
}

enum JobPayloadDTO {

    case blackList([JobBlackListDTO])

    case direction(String)

    case lockState(String)
}


