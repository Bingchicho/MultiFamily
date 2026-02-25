//
//  AddViewData.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/25.
//

struct AddDeviceViewData: Equatable {
    // 直接給 VC 使用（避免 VC 自己拼字串/判斷）
    let nameText: String
    let areaTitle: String
    let autoLockOn: Bool
    let autoTimeTitle: String
    let autoTimeEnabled: Bool
    let beepOn: Bool
    let txPowerTitle: String
    let advTitle: String
 


}
