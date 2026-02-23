//
//  Setting.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//


enum BLETxPower: Int, CaseIterable, Equatable {
    case low = 30
    case medium = 60
    case high = 90

    var title: String {
        switch self {
        case .low: return L10n.Detail.Low.title
        case .medium: return L10n.Detail.Middle.title
        case .high: return L10n.Detail.Hight.title
        }
    }
}

enum BLEAdv: Int, CaseIterable, Equatable {
    case low = 30
    case high = 90

    var title: String {
        switch self {
        case .low: return L10n.Detail.Low.title
        case .high: return L10n.Detail.Hight.title
        }
    }
}


/// 這頁面表單狀態（ViewModel 內維護）
struct RegistryForm: Equatable {

    var name: String = ""

    var isAutoLockOn: Bool = false
    var autoLockDelay: Int? = nil

    var isBeepOn: Bool = false

    var txPower: BLETxPower = .low
    var adv: BLEAdv = .low
}


