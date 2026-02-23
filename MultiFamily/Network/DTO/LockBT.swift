//
//  LockBT.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

import Foundation

// MARK: - Shared: BT
struct LockBTDTO: Codable {
    /// update request 需要 uuid
    let uuid: String?
    let key: String?
    let token: String?
    let iv: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case key
        case token
        case iv

        // detail response 裡用 "bt" 當 uuid 字段
        case bt
    }

    init(uuid: String? = nil, key: String? = nil, token: String? = nil, iv: String? = nil) {
        self.uuid = uuid
        self.key = key
        self.token = token
        self.iv = iv
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        // 同時支援 response 的 "bt" 或 "uuid"
        let uuidFromUUID = try c.decodeIfPresent(String.self, forKey: .uuid)
        let uuidFromBT = try c.decodeIfPresent(String.self, forKey: .bt)
        self.uuid = uuidFromUUID ?? uuidFromBT

        self.key = try c.decodeIfPresent(String.self, forKey: .key)
        self.token = try c.decodeIfPresent(String.self, forKey: .token)
        self.iv = try c.decodeIfPresent(String.self, forKey: .iv)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)

        // request 只送 uuid，不送 bt
        try c.encodeIfPresent(uuid, forKey: .uuid)
        try c.encodeIfPresent(key, forKey: .key)
        try c.encodeIfPresent(token, forKey: .token)
        try c.encodeIfPresent(iv, forKey: .iv)
    }
}

// MARK: - Shared: Attributes (全部 optional，nil 就不出 key)
struct DeviceAttributesDTO: Codable {

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

    let updateAt: Int? // detail response 才有

    enum CodingKeys: String, CodingKey {
        case location, direction, accessCode, preamble, virtualCode, twoFA, vacationMode
        case autoLock, autoLockDelay, autoLockDelayMin, autoLockDelayMax
        case operatorVoice, voiceType, voiceValue
        case showFastPassageMode, sabbathMode
        case voiceLanguage, voiceLanguageSupport
        case timezone, mcuVersion
        case bleTXPower, bleAdv, battery
        case updateAt
    }
}
