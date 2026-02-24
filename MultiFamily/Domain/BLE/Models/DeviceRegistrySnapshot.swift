//
//  DeviceRegistrySnapshot.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation

/// ✅ 這是「從 BLE 裝置讀回來的結果」
/// - 先用最小集合：例如電量、mcuVersion、timezone
/// - 之後再慢慢加你需要的欄位
public struct DeviceRegistrySnapshot: Equatable, Sendable {
    public let location: String
    public let direction: String
    public let accessCode: String
    public let preamble: String
    public let virtualCode: String
    public let twoFA: String
    public let vacationMode: String
    public let autoLock: String

    public let autoLockDelay: Int?
    public let autoLockDelayMin: Int?
    public let autoLockDelayMax: Int?

    public let operatorVoice: String
    public let voiceType: Int?
    public let voiceValue: Int?
    public let showFastPassageMode: String
    public let sabbathMode: String
    public let voiceLanguage: Int?
    public let voiceLanguageSupport: Int?
    public let timezone: String
    public let mcuVersion: String
    public let bleTXPower: Int?
    public let bleAdv: Int?

    public init(
        location: String?,
        direction: String?,
        accessCode: String?,
        preamble: String?,
        virtualCode: String?,
        twoFA: String?,
        vacationMode: String?,
        autoLock: String?,
        autoLockDelay: Int?,
        autoLockDelayMin: Int?,
        autoLockDelayMax: Int?,
        operatorVoice: String?,
        voiceType: Int?,
        voiceValue: Int?,
        showFastPassageMode: String?,
        sabbathMode: String?,
        voiceLanguage: Int?,
        voiceLanguageSupport: Int?,
        timezone: String?,
        mcuVersion: String?,
        bleTXPower: Int?,
        bleAdv: Int?
    ) {
        self.location = location ?? "N"
        self.direction = direction ?? "N"
        self.accessCode = accessCode ?? "N"
        self.preamble = preamble ?? "N"
        self.virtualCode = virtualCode ?? "N"
        self.twoFA = twoFA ?? "N"
        self.vacationMode = vacationMode ?? "N"
        self.autoLock = autoLock ?? "N"

        self.autoLockDelay = autoLockDelay
        self.autoLockDelayMin = autoLockDelayMin
        self.autoLockDelayMax = autoLockDelayMax

        self.operatorVoice = operatorVoice ?? "N"
        self.voiceType = voiceType
        self.voiceValue = voiceValue
        self.showFastPassageMode = showFastPassageMode ?? "N"
        self.sabbathMode = sabbathMode ?? "N"
        self.voiceLanguage = voiceLanguage
        self.voiceLanguageSupport = voiceLanguageSupport
        self.timezone = timezone ?? "Asia/Taipei"
        self.mcuVersion = mcuVersion ?? "0.0.0"
        self.bleTXPower = bleTXPower
        self.bleAdv = bleAdv
    }
}
