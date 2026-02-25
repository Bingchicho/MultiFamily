//
//  Add.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/25.
//

enum LockArea: String, CaseIterable, Equatable {
    case `private` = "Private"
    case `public`  = "Public"
    
    var title: String {
        switch self {
        case .private: return "Private"
        case .public: return "Public"

        }
    }
}

struct AddForm: Equatable {
    var lockID: String = ""          // 顯示用（通常不可編）
    var name: String = ""            // 必填
    var area: LockArea? = nil        // 必填

    var isAutoLockOn: Bool = false
    var autoLockDelay: Int? = nil    // isAutoLockOn == true 時必填 (1...120)

    var isBeepOn: Bool = false

    var txPower: BLETxPower = .medium
    var adv: BLEAdv = .low

    var group: String? = nil         // optional（你畫面有 Group）
}
