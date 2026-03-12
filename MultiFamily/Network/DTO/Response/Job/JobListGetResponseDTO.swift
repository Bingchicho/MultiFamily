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
    let payloadVersion: String?

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
public struct JobSettingDTO: Decodable, Equatable {
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

public extension JobSettingDTO {

    enum Patch: Equatable {
        case location(String)
        case direction(String)
        case accessCode(String)
        case preamble(String)
        case virtualCode(String)
        case twoFA(String)
        case vacationMode(String)
        case autoLock(String)
        case autoLockDelay(Int)
        case autoLockDelayMin(Int)
        case autoLockDelayMax(Int)
        case operatorVoice(String)
        case voiceType(Int, Int)
        case showFastPassageMode(String)
        case sabbathMode(String)
        case voiceLanguage(Int)
        case voiceLanguageSupport(Int)
        case timezone(String)
        case mcuVersion(String)
        case bleTXPower(Int)
        case bleAdv(Int)
        case battery(Int)
    }

    /// Returns only the fields that actually need to update downstream payload/config.
    var patches: [Patch] {
        var result: [Patch] = []

        if let location { result.append(.location(location)) }
        if let direction { result.append(.direction(direction)) }
        if let accessCode { result.append(.accessCode(accessCode)) }
        if let preamble { result.append(.preamble(preamble)) }
        if let virtualCode { result.append(.virtualCode(virtualCode)) }
        if let twoFA { result.append(.twoFA(twoFA)) }
        if let vacationMode { result.append(.vacationMode(vacationMode)) }
        if let autoLock { result.append(.autoLock(autoLock)) }
        if let autoLockDelay { result.append(.autoLockDelay(autoLockDelay)) }
        if let autoLockDelayMin { result.append(.autoLockDelayMin(autoLockDelayMin)) }
        if let autoLockDelayMax { result.append(.autoLockDelayMax(autoLockDelayMax)) }
        if let operatorVoice { result.append(.operatorVoice(operatorVoice)) }
        if let voiceType {result.append(.voiceType(voiceType, voiceValue ?? 0)) }
//        if let voiceType { result.append(.voiceType(voiceType)) }
//        if let voiceValue { result.append(.voiceValue(voiceValue)) }
        if let showFastPassageMode { result.append(.showFastPassageMode(showFastPassageMode)) }
        if let sabbathMode { result.append(.sabbathMode(sabbathMode)) }
        if let voiceLanguage { result.append(.voiceLanguage(voiceLanguage)) }
        if let voiceLanguageSupport { result.append(.voiceLanguageSupport(voiceLanguageSupport)) }
        if let timezone { result.append(.timezone(timezone)) }
        if let mcuVersion { result.append(.mcuVersion(mcuVersion)) }
        if let bleTXPower { result.append(.bleTXPower(bleTXPower)) }
        if let bleAdv { result.append(.bleAdv(bleAdv)) }
        if let battery { result.append(.battery(battery)) }

        return result
    }
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
