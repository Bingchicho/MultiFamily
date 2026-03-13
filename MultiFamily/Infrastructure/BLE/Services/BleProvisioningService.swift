//
//  BleProvisioningService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation
import MFRBleSDK

public protocol ProvisioningService {
    /// Provision 流程：用 btInfo 連上去，讀出 registry 類資料
    var status: LockStatus? { get }
    func connection() async throws

    func provisionAndFetchRegistry(btInfo: ProvisionBLEInfo, addform: AddForm, siteID: String) async throws
}


/// ✅ 實作 BLEService：把「流程」寫在這裡
/// - 這裡不 import MFRBleSDK
/// - 只用 BleClient
public final class BleProvisioningService: ProvisioningService {
    public var status: LockStatus?
    
    public func connection() async throws {
        try await client.connect(targetUID: nil)
    }
    
    private let client: BleClient

    public init(client: BleClient) {
        self.client = client
        self.status = client.status
    }

    public func provisionAndFetchRegistry(btInfo: ProvisionBLEInfo, addform: AddForm, siteID: String) async throws {
        // 流程：connect → read → disconnect（用 defer 確保離開時斷線）
     
        defer { Task { await client.disconnect() } }
        
        try await client.readRegistrySnapshot(info: btInfo, addform: addform, siteID: siteID)
        self.status = client.status
    }
}
