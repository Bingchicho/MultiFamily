//
//  BleLockUnlockService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/25.
//


import Foundation
import MFRBleSDK

public protocol LockUnlockService {
    
    var isConnectedStream: AsyncStream<Bool> { get }
  
    var status: LockStatus? { get }
    func connection(device: Device) async throws
    func disconnect() async throws

    func LockAction(lock: Bool, device: Device) async throws

}


/// ✅ 實作 BLEService：把「流程」寫在這裡
/// - 這裡不 import MFRBleSDK
/// - 只用 BleClient
public final class BleLockUnlockService: LockUnlockService {
    public var isConnectedStream: AsyncStream<Bool> {
        client.isConnectedStream
    }
    
 
    
    public func disconnect() async throws {
         await client.disconnect()
        status = nil
    }
    

    public var status: LockStatus?
    
    public func connection(device: Device) async throws {
        client.updateBt(device: device)
        try await client.connect(targetUID: String(device.id))
        // 取得Version 要跟job的version 判斷
        try await client.getStatus()
        self.status = client.status
    }
    
    private let client: BleClient

    public init(client: BleClient) {
        self.client = client
     
    }

    public func LockAction(lock: Bool, device: Device) async throws {
        
        if client.isConnected {
            try await client.LockAction(lock: lock)
            try await client.getStatus()
            self.status = client.status
        } else {
            try await connection(device: device)
        }
        
    }
    
 
}
