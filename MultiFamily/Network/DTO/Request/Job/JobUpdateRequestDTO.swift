//
//  JobUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct JobUpdateRequestDTO: Encodable {

    let applicationID: String
    let jobID: String
    let status: JobStatusDTO
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case jobID
        case status
        case clientToken
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(applicationID, forKey: .applicationID)
        try container.encode(jobID, forKey: .jobID)
        try container.encode(status.value, forKey: .status)
        try container.encode(clientToken, forKey: .clientToken)
    }
}

enum JobStatusDTO: Equatable, Decodable {

    case revoke
    case conflict
    case initial
    case start
    case error
    case wait
    case onflight
    case done
    case reject
    case timeout

    case unknown(String)

    var value: String {
        switch self {
        case .revoke: return "revoke"
        case .conflict: return "conflict"
        case .initial: return "initial"
        case .start: return "start"
        case .error: return "error"
        case .wait: return "wait"
        case .onflight: return "onflight"
        case .done: return "done"
        case .reject: return "reject"
        case .timeout: return "timeout"
        case .unknown(let v): return v
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "revoke": self = .revoke
        case "conflict": self = .conflict
        case "initial": self = .initial
        case "start": self = .start
        case "error": self = .error
        case "wait": self = .wait
        case "onflight": self = .onflight
        case "done": self = .done
        case "reject": self = .reject
        case "timeout": self = .timeout
        default: self = .unknown(rawValue)
        }
    }
}
