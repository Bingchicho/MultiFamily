//
//  BleClient.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation
import MFRBleSDK

/// ✅ 連線層抽象：像 socket 一樣
/// - Service 需要連線，就呼叫這個
/// - Service 不該知道底下用 MFRBleSDK 還是 CoreBluetooth
public protocol BleClient {
    var isConnected: Bool { get }
    var status: LockStatus? { get }

    func connect() async throws
    func disconnect() async

    /// 下面這些你可以按需求加（先不做也行）
    func readRegistrySnapshot(info: ProvisionBLEInfo, addform: AddForm, siteID: String) async throws 
}
