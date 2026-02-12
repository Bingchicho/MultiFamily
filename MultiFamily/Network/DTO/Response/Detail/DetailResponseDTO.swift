//
//  DetailResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import Foundation

struct DetailResponseDTO: Decodable {

    let applicationID: String
    let uuid: String
    let siteID: String
    let thingName: String
    let activeMode: String
    let deviceID: UInt16
    let model: String
    let name: String
    let createAt: TimeInterval
    let isResident: Bool
    let remotePinCode: String?
    let installationNotComplete: Bool?
    let bt: DetailBTDTO
    let attributes: DetailAttributesDTO

    let clientToken: String

}


struct DetailBTDTO: Decodable {

    let uuid: String
    let key: String
    let token: String
    let iv: String

}

struct DetailAttributesDTO: Decodable {

    let location: String?
    let timezone: String

    let mcuVersion: String
    let direction: String

    let accessCode: String
    let preamble: String
    let virtualCode: String

    let twoFA: String
    let vacationMode: String

    let autoLock: String
    let autoLockDelay: Int
    let autoLockDelayMin: Int
    let autoLockDelayMax: Int

    let operatorVoice: String

    let voiceType: Int
    let voiceValue: Int

    let showFastPassageMode: String
    let sabbathMode: String

    let voiceLanguage: Int
    let voiceLanguageSupport: Int

    let bleTXPower: Int
    let bleAdv: Int

    let battery: Int

    let updateAt: TimeInterval

}


extension DetailResponseDTO {

    func toDomain() -> Detail {

        let date = Date(timeIntervalSince1970: attributes.updateAt)
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy/MM/dd HH:mm"

        let formattedUpdateAt = formatter.string(from: date)

        return Detail(
            thingName: thingName,
            name: name,
            model: model,
            battery: attributes.battery,
            isResident: isResident,
            beep: attributes.operatorVoice == "Y",
            autoLock: attributes.autoLock == "Y",
            autoLockDelay: attributes.autoLockDelay,
            btUUID: bt.uuid,
            btKey: bt.key,
            btToken: bt.token,
            btIV: bt.iv,
            bleTxPower: attributes.bleTXPower,
            bleAdv: attributes.bleAdv,
            updateAt: formattedUpdateAt
        )
    }

}
