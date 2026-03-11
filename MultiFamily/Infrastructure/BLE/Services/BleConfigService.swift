//
//  BleConfigService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//

public protocol ConfigService {
 

    func connection() async throws

     func setupSetting(value: JobSettingDTO) async throws
}

public final class BleConfigService: ConfigService {


    
    public func connection() async throws {
        try await client.connect()
    }
    
    private let client: BleClient

    public init(client: BleClient) {
        self.client = client
      
    }

    public func setupSetting(value: JobSettingDTO) async throws {
        // 流程：connect → read → disconnect（用 defer 確保離開時斷線）
     
        defer { Task { await client.disconnect() } }
        
        try await client.setupSetting(value: value)
       
    }
}
