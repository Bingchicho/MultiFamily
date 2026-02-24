//
//  DeviceAddRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation

// MARK: - Request

struct DeviceAddRequestDTO: Encodable {
    let applicationID: String
    let siteID: String
    let name: String
    let activeMode: String // "ble" / "wifi"
    let model: String
    let isResident: Bool
    let deviceID: Int // uint16
    let remotePinCode: String

    let bt: DeviceAddBTRequestDTO
    let attributes: DeviceAddAttributesDTO

    let clientToken: String
}

struct DeviceAddBTRequestDTO: Encodable {
    let uuid: String
    let key: String
    let token: String
    let iv: String
}

struct DeviceAddAttributesDTO: Encodable {

    // String flags (通常 "N"/"F"/"T" 這種)
    let location: String?
    let direction: String?
    let accessCode: String?
    let preamble: String?
    let virtualCode: String?
    let twoFA: String?
    let vacationMode: String?
    let autoLock: String?
    let operatorVoice: String?
    let showFastPassageMode: String?
    let sabbathMode: String?
    let timezone: String?
    let mcuVersion: String?

    // Int fields
    let autoLockDelay: Int?
    let autoLockDelayMin: Int?
    let autoLockDelayMax: Int?
    let voiceType: Int?
    let voiceValue: Int?
    let voiceLanguage: Int?
    let voiceLanguageSupport: Int?
    let bleTXPower: Int?
    let bleAdv: Int?

    // 如果你確定一定會帶，就改成非 Optional
    init(
        location: String? = nil,
        direction: String? = nil,
        accessCode: String? = nil,
        preamble: String? = nil,
        virtualCode: String? = nil,
        twoFA: String? = nil,
        vacationMode: String? = nil,
        autoLock: String? = nil,
        autoLockDelay: Int? = nil,
        autoLockDelayMin: Int? = nil,
        autoLockDelayMax: Int? = nil,
        operatorVoice: String? = nil,
        voiceType: Int? = nil,
        voiceValue: Int? = nil,
        showFastPassageMode: String? = nil,
        sabbathMode: String? = nil,
        voiceLanguage: Int? = nil,
        voiceLanguageSupport: Int? = nil,
        timezone: String? = nil,
        mcuVersion: String? = nil,
        bleTXPower: Int? = nil,
        bleAdv: Int? = nil
    ) {
        self.location = location
        self.direction = direction
        self.accessCode = accessCode
        self.preamble = preamble
        self.virtualCode = virtualCode
        self.twoFA = twoFA
        self.vacationMode = vacationMode
        self.autoLock = autoLock
        self.autoLockDelay = autoLockDelay
        self.autoLockDelayMin = autoLockDelayMin
        self.autoLockDelayMax = autoLockDelayMax
        self.operatorVoice = operatorVoice
        self.voiceType = voiceType
        self.voiceValue = voiceValue
        self.showFastPassageMode = showFastPassageMode
        self.sabbathMode = sabbathMode
        self.voiceLanguage = voiceLanguage
        self.voiceLanguageSupport = voiceLanguageSupport
        self.timezone = timezone
        self.mcuVersion = mcuVersion
        self.bleTXPower = bleTXPower
        self.bleAdv = bleAdv
    }
}

extension DeviceAddAttributesDTO {
    /// 你之前提到「String? 是 nil 時要帶入 'N'」
    /// 用這個 helper 產 request 時統一補預設值（但仍可選擇要不要 encode 出去）
    func normalizedNilStringAsN() -> DeviceAddAttributesDTO {
        DeviceAddAttributesDTO(
            location: location ?? "N",
            direction: direction ?? "N",
            accessCode: accessCode ?? "N",
            preamble: preamble ?? "N",
            virtualCode: virtualCode ?? "N",
            twoFA: twoFA ?? "N",
            vacationMode: vacationMode ?? "N",
            autoLock: autoLock ?? "N",
            autoLockDelay: autoLockDelay,
            autoLockDelayMin: autoLockDelayMin,
            autoLockDelayMax: autoLockDelayMax,
            operatorVoice: operatorVoice ?? "N",
            voiceType: voiceType,
            voiceValue: voiceValue,
            showFastPassageMode: showFastPassageMode ?? "N",
            sabbathMode: sabbathMode ?? "N",
            voiceLanguage: voiceLanguage,
            voiceLanguageSupport: voiceLanguageSupport,
            timezone: timezone ?? "N",
            mcuVersion: mcuVersion ?? "N",
            bleTXPower: bleTXPower,
            bleAdv: bleAdv
        )
    }
}
