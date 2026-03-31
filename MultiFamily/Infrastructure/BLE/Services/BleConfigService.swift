//
//  BleConfigService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//



import MFRBleSDK
public protocol JobService {

    var version: String? { get }
    func connection(device: Device) async throws

    func setupJobSetting(value: JobSettingDTO) async throws
    func setupSetting(value: RegistryForm) async throws
}

public final class BleConfigService: JobService {

    
    public var version: String?
    
    public func connection(device: Device) async throws {
        client.updateBt(device: device)
        try await client.connect(targetUID: String(device.id))
        // 取得Version 要跟job的version 判斷
        try await client.getStatus()
        self.version = client.config?.boardVersionString
    }
    
    private let client: BleClient

    public init(client: BleClient) {
        self.client = client
        self.version = client.config?.boardVersionString
      
    }

    public func setupJobSetting(value: JobSettingDTO) async throws {
        // 流程：connect → read → disconnect（用 defer 確保離開時斷線）
     
        defer { Task { await client.disconnect() } }
        try await client.setupJobSetting(value: value)
       
    }
    
    public func setupSetting(value: RegistryForm) async throws {
        defer { Task { await client.disconnect() } }
        try await client.setupSetting(value: value)
    }
}
