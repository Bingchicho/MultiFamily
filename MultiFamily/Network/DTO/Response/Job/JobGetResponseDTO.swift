//
//  JobGetResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//
import Foundation



struct JobGetResponseDTO: Decodable {
    let count: Int
    let applicationID: String
    let thingName: String
    let siteID: String
    let job: JobDTO?
    let next: Bool
    let clientToken: String
}

struct JobDTO: Decodable {
    let jobID: String
    let status: String
    let action: JobActionDTO
    let blackList: [JobBlackListDTO]?
}

enum JobActionDTO: Decodable, Equatable {

    case setting
    case blacklist
    case pinCodeOrUserCredential
    case direction
    case lockState
    case factory
    case unknown(Int)

    var value: Int {
        switch self {
        case .setting: return 1
        case .blacklist: return 2
        case .pinCodeOrUserCredential: return 4
        case .direction: return 5
        case .lockState: return 6
        case .factory: return 255
        case .unknown(let v): return v
        }
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)

        switch rawValue {
        case 1: self = .setting
        case 2: self = .blacklist
        case 4: self = .pinCodeOrUserCredential
        case 5: self = .direction
        case 6: self = .lockState
        case 255: self = .factory
        default: self = .unknown(rawValue)
        }
    }
}
struct JobBlackListDTO: Codable {
    let using: Bool
    let credentialType: Int
    let data: String
}
