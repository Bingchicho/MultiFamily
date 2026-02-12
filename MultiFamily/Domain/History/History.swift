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

    case pinCreate = 80
    case pinUpdate = 81
    case pinDelete = 82

    case errorPin = 128

    case shareCreate = 1001
    case shareExpire = 1002
    case shareAccept = 1003

    case shareUserUpdate = 65
    case shareUserDelete = 66

    case unknown

    init(rawValue: Int) {
        self = HistoryType(rawValue: rawValue)
    }
}

extension HistoryType {

    var displayName: String {

        switch self {

        case .autoLock:
            return "Auto locked"

        case .appUnlock:
            return "Unlocked via App"

        case .accessCodeUnlock:
            return "Unlocked via Code"

        default:
            return "Unknown"
        }
    }
}
