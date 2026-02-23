//
//  Setting.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//


enum BLETxPower: Int, CaseIterable {
    case low = 30
    case medium = 60
    case high = 90

    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Middle"
        case .high: return "High"
        }
    }
}

enum BLEAdv: Int, CaseIterable {
    case low = 30
    case high = 90

    var title: String {
        switch self {
        case .low: return "Low"
        case .high: return "High"
        }
    }
}


/// 這頁面表單狀態（ViewModel 內維護）
struct RegistryForm {

    var name: String = ""

    var isAutoLockOn: Bool = false
    var autoLockDelay: Int? = nil

    var isBeepOn: Bool = false

    var txPower: BLETxPower = .medium
    var adv: BLEAdv = .low
}
