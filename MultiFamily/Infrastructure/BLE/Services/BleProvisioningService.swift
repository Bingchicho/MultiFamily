//
//  BleProvisioningService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation

/// ✅ 實作 BLEService：把「流程」寫在這裡
/// - 這裡不 import MFRBleSDK
/// - 只用 BleClient
public final class BleProvisioningService: BLEService {
    
    public func connection() async throws {
        try await client.connect()
    }
    
    private let client: BleClient

    public init(client: BleClient) {
        self.client = client
    }

//    public func provisionAndFetchRegistry(btInfo: ProvisionBLEInfo) async throws -> DeviceRegistrySnapshot {
//        // 流程：connect → read → disconnect（用 defer 確保離開時斷線）
//     
//        defer { Task { await client.disconnect() } }
//        
//        let snapshot = try await client.readRegistrySnapshot(info: btInfo)
//        return snapshot
//    }
}
