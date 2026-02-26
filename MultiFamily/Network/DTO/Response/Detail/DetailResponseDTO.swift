//
//  DetailResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import Foundation

// MARK: - DTO

struct DetailResponseDTO: Decodable {

    let applicationID: String?
    let uuid: String?
    let siteID: String?
    let thingName: String
    let activeMode: String?
    let deviceID: UInt16?
    let model: String?
    let name: String?
    let createAt: TimeInterval?
    let isResident: Bool?
    let remotePinCode: String?
    let installationNotComplete: Bool?
    let bt: DetailBTDTO?
    let attributes: DetailAttributesDTO?

    let clientToken: String?
}

// MARK: - BT DTO (支援 uuid / bt 兩種格式)

struct DetailBTDTO: Decodable {

    let uuid: String?
    let key: String?
    let token: String?
    let iv: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case bt
        case key
        case token
        case iv
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 有些後端用 uuid，有些用 bt
        self.uuid = (try? container.decodeIfPresent(String.self, forKey: .uuid))
            ?? (try? container.decodeIfPresent(String.self, forKey: .bt))

        self.key = try? container.decodeIfPresent(String.self, forKey: .key)
        self.token = try? container.decodeIfPresent(String.self, forKey: .token)
        self.iv = try? container.decodeIfPresent(String.self, forKey: .iv)
    }
}

// MARK: - Attributes DTO (全部 optional，避免 keyNotFound)

struct DetailAttributesDTO: Decodable {

    let location: String?
    let timezone: String?

    let mcuVersion: String?
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

    let bleTXPower: Int?
    let bleAdv: Int?

    let battery: Int?

    let updateAt: TimeInterval?
}

// MARK: - Helper

private extension String {
    /// Backend 可能傳 Y/N, T/F, true/false, 1/0
    var backendBool: Bool {
        let v = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return v == "y" || v == "t" || v == "true" || v == "1"
    }
}

private enum DetailFormatter {
    static let updateAt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
}

// MARK: - Domain Mapping

extension DetailResponseDTO {

    func toDomain() -> Detail {

        let attrs = attributes

        let formattedUpdateAt: String = {
            guard let ts = attrs?.updateAt else { return "" }
            let date = Date(timeIntervalSince1970: ts)
            return DetailFormatter.updateAt.string(from: date)
        }()

        let beep = (attrs?.operatorVoice ?? "").backendBool
        let autoLock = (attrs?.autoLock ?? "").backendBool

        return Detail(
            thingName: thingName,
            name: name ?? "",
            model: model ?? "",
            battery: attrs?.battery ?? 0,
            isResident: isResident ?? false,
            beep: beep,
            autoLock: autoLock,
            autoLockDelay: attrs?.autoLockDelay ?? 0,
            btUUID: bt?.uuid ?? "",
            btKey: bt?.key ?? "",
            btToken: bt?.token ?? "",
            btIV: bt?.iv ?? "",
            bleTxPower: attrs?.bleTXPower ?? 0,
            bleAdv: attrs?.bleAdv ?? 0,
            updateAt: formattedUpdateAt
        )
    }
}
