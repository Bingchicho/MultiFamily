//
//  History.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation

struct History {

    let type: HistoryType
    let from: String?
    let to: String?
    let message: String?
    let date: Date

}

enum HistoryType: Int {

    case autoLock = 0
    case autoLockFail = 1
    case appLock = 2
    case appLockFail = 3
    case keyLock = 4
    case keyLockFail = 5
    case manualLock = 6
    case manualLockFail = 7

    case appUnlock = 8
    case appUnlockFail = 9
    case accessCodeUnlock = 10
    case accessCodeUnlockFail = 11
    case manualUnlock = 12
    case manualUnlockFail = 13
    case cardUnlock = 14
    case cardUnlockFail = 15
    case fingerprintUnlock = 16
    case fingerprintUnlockFail = 17
    case faceUnlock = 18
    case faceUnlockFail = 19
    case twoFAUnlock = 20
    case twoFAUnlockFail = 21

    case pinCreate = 80
    case pinUpdate = 81
    case pinDelete = 82
    case ota = 95

    case errorPin = 128
    case connectionError = 129
    case wrongTimeAccess = 130
    case vacationModeError = 131
    case wrongCard = 132
    case wrongFingerprint = 133
    case wrongFace = 134
    case twoFAError = 135
    case otaLowBattery = 136

    case shareCreate = 1001
    case shareExpire = 1002
    case shareAccept = 1003

    case shareUserUpdate = 65
    case shareUserDelete = 66

    case unknown

    init(value: Int) {
         self = HistoryType(rawValue: value) ?? .unknown
     }
}

extension HistoryType {

    var displayName: String {

        switch self {

        case .autoLock: return "Auto lock success"
        case .autoLockFail: return "Auto lock failed"

        case .appLock: return "App lock success"
        case .appLockFail: return "App lock failed"

        case .appUnlock: return "App unlock success"
        case .appUnlockFail: return "App unlock failed"

        case .accessCodeUnlock: return "Code unlock success"
        case .accessCodeUnlockFail: return "Code unlock failed"

        case .cardUnlock: return "Card unlock success"
        case .cardUnlockFail: return "Card unlock failed"

        case .fingerprintUnlock: return "Fingerprint unlock success"
        case .fingerprintUnlockFail: return "Fingerprint unlock failed"

        case .faceUnlock: return "Face unlock success"
        case .faceUnlockFail: return "Face unlock failed"

        case .twoFAUnlock: return "2FA unlock success"
        case .twoFAUnlockFail: return "2FA unlock failed"

        case .ota: return "OTA update"

        case .errorPin: return "Wrong PIN"
        case .connectionError: return "Connection error"
        case .wrongTimeAccess: return "Invalid time access"
        case .vacationModeError: return "Vacation mode restriction"
        case .wrongCard: return "Invalid card"
        case .wrongFingerprint: return "Invalid fingerprint"
        case .wrongFace: return "Invalid face"
        case .twoFAError: return "2FA error"
        case .otaLowBattery: return "OTA failed (low battery)"

        default:
            return "Unknown"
        }
    }
}
