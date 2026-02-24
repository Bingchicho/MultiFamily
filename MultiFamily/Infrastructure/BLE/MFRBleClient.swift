//
//  MFRBleClient.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation
import MFRBleSDK

/// ✅ 唯一 import MFRBleSDK 的地方
/// - 把 SDK callback 包成 async/await
/// - 把 SDK 型別/錯誤隔離在這層
public final class MFRBleClient: BleClient {

    private let sdk: MFRBleSDK
    public private(set) var isConnected: Bool = false

    public init() {
        self.sdk = MFRBleSDK()
        self.sdk.isDebugLogEnabled = true
        observe()
      
    }
    
    private func observe() {
        sdk.onDebugLog = { [weak self] log in
            guard self != nil else { return }
            AppLogger.log(.info, category: .bluetooth, log)
        }
        sdk.onEvent = { [weak self] event in
            guard self != nil else { return }
            switch event.kind {
            case .alert(let type):
                AppLogger.log(.info, category: .bluetooth, "alert: 🔔 \(type)")
             
            case .otaCompleted(let requiresSync):
                AppLogger.log(.info, category: .bluetooth, "otaCompleted: 🔔 \(requiresSync)")
               
            case .unknown(let function, let raw):
                AppLogger.log(.info, category: .bluetooth, "unknown: 🔔 \(function), \(raw)")
              
            }
        }
    }

    public func connect() async throws {
        if isConnected { return }

        // TODO: 替換成你 SDK 真正的 connect/handshake 流程
        try await withCheckedThrowingContinuation { continuation in
            // 假想：sdk.connect(uuid:key:token:iv:completion:)
            sdk.connect { result in
                switch result {
                case .success:
                    self.isConnected = true
                    continuation.resume()
                case .failure(let error):
                    self.isConnected = false
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func disconnect() async {
        guard isConnected else { return }

        // TODO: 替換成你 SDK 真正的 disconnect
        sdk.disconnect()
        isConnected = false
    }

//    public func readRegistrySnapshot(info: ProvisionBLEInfo) async throws -> DeviceRegistrySnapshot {
//        guard isConnected else {
//            throw NSError(domain: "BLE", code: -1, userInfo: [NSLocalizedDescriptionKey: "BLE not connected"])
//        }
//
//        // TODO: 用 SDK 實際 API 讀值，組回 DeviceRegistrySnapshot
//        // 這裡示範假資料
////        return DeviceRegistrySnapshot(
////            battery: 80,
////            mcuVersion: "0.0.1",
////            timezone: "Asia/Taipei"
////        )
//    }
}
