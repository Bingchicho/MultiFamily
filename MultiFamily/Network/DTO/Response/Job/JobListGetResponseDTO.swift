//
//  JobListGetResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct JobListGetResponseDTO: Decodable {

    let count: Int
    let applicationID: String
    let thingName: String
    let siteID: String
    let jobs: [JobListItemDTO]
    let clientToken: String?

    enum CodingKeys: String, CodingKey {
        case count
        case applicationID
        case thingName
        case siteID
        case jobs
        case clientToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        self.applicationID = try container.decodeIfPresent(String.self, forKey: .applicationID) ?? ""
        self.thingName = try container.decodeIfPresent(String.self, forKey: .thingName) ?? ""
        self.siteID = try container.decodeIfPresent(String.self, forKey: .siteID) ?? ""
        self.jobs = try container.decodeIfPresent([JobListItemDTO].self, forKey: .jobs) ?? []
        self.clientToken = try container.decodeIfPresent(String.self, forKey: .clientToken)
    }
}

struct JobListItemDTO: Decodable {

    let jobID: String
    let status: JobStatusDTO
    let action: JobActionDTO
    let payloadVersion: Int?

    let setting: JobSettingDTO?
    let blackList: [JobBlackListDTO]?
    let userCredential: JobUserCredentialDTO?
    let restoreCard: JobRestoreCardDTO?
    let direction: String?
    let lockState: String?

    enum CodingKeys: String, CodingKey {
        case jobID
        case status
        case action
        case payloadVersion
        case setting
        case blackList
        case userCredential = "user-credential"
        case restoreCard
        case direction
        case lockState
    }
}


/// same as device-registry
struct JobSettingDTO: Decodable {
    let location: String?
    let direction: String?
    let accessCode: String?
    let preamble: String?
    let virtualCode: String?
    let twoFA: String?
    let vacationMode: String?
    let autoLock: String?
    let autoLockDelay: Int?
    let autoLockDelayMin: Int?
    let autoLockDelayMax: Int?
    let operatorVoice: String?
    let voiceType: Int?
    let voiceValue: Int?
    let showFastPassageMode: String?
    let sabbathMode: String?
    let voiceLanguage: Int?
    let voiceLanguageSupport: Int?
    let timezone: String?
    let mcuVersion: String?
    let bleTXPower: Int?
    let bleAdv: Int?
    let battery: Int?
}



/// same as user-credential
struct JobUserCredentialDTO: Decodable {
    let userIndex: Int?
    let userName: String?
    let userStatus: Int?
    let userType: Int?
    let credentialRule: Int?
    let credentialIndex: Int?
    let credentialType: Int?
    let credentialData: String?
}

struct JobRestoreCardDTO: Decodable {
    let resetMask: Int?
    let pincode: String?
}
