//
//  AddViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/25.
//

enum AddDeviceViewState: Equatable {
    case idle
    case loading
    case success        // 成功後提示 + 關閉
    case error(String)
}
