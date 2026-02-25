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

   
        try await withCheckedThrowingContinuation { continuation in
   
            sdk.connect { result in
                switch result {
                case .success:
                
                    let tz = TimeZone.current
                    self.sdk.setDeviceTime(date: Date(), timeZone: tz) { result in
                        switch result {
                        case .success:
                            self.isConnected = true
                            continuation.resume()
                        case .failure(let error):
                            self.sdk.disconnect()
                            self.isConnected = false
                            continuation.resume(throwing: error)
                        }
                    }
                    
                case .failure(let error):
                    self.isConnected = false
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func disconnect() async {
        guard isConnected else { return }

        sdk.disconnect()
        isConnected = false
    }

    // MARK: - SDK callback -> async helpers

    private func sdkSetUID(_ config: UIDConfig) async throws {
        try await withCheckedThrowingContinuation { continuation in
            sdk.setUID(config) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func sdkSetKeyOne(_ config: KeyOneConfig) async throws {
        try await withCheckedThrowingContinuation { continuation in
            sdk.setKeyOne(config) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func sdkAddBleUser(_ request: BleUserCreateRequest) async throws {
        try await withCheckedThrowingContinuation { continuation in
            sdk.addBleUser(request) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func sdkSetRemotePinCodeRandom(_ config: RemotePinCodeRandomConfig) async throws {
        try await withCheckedThrowingContinuation { continuation in
            sdk.setRemotePinCodeRandom(config) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func readRegistrySnapshot(info: ProvisionBLEInfo, addform: AddForm, siteID: String) async throws {
        guard isConnected else {
            throw NSError(domain: "BLE", code: -1, userInfo: [NSLocalizedDescriptionKey: "BLE not connected"])
        }

     
        let uidConfig = UIDConfig(siteCode: siteID,
                                  uid: info.uuid,
                                  doorType: addform.area == .private ? .resident : .publicDoor)
        
        do {
            // 1) set UID
            try await sdkSetUID(uidConfig)

            // 2) set KeyOne
            let keyoneConfig = KeyOneConfig(
                aesKeyHex: info.key,
                ivHex: info.iv,
                cardAesKeyHex: "00000000000000000000000000000000",
                cardSaltHex: "0000000000000000"
            )
            try await sdkSetKeyOne(keyoneConfig)

            // 3) add BLE user
            let bleUserCreateRequest = try BleUserCreateRequest(
                index: 0,
                role: .owner,
                tokenHex: info.token,
                startTime: Date(),
                endTime: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                identity: addform.name
            )
            try await sdkAddBleUser(bleUserCreateRequest)

            // 4) set remote pin code random
            let pincodeRequest = RemotePinCodeRandomConfig(hexString: info.remotePinCode)
            try await sdkSetRemotePinCodeRandom(pincodeRequest)

            // ✅ Only reach here means ALL steps succeeded
            AppLogger.log(.info, category: .bluetooth, "readRegistrySnapshot ✅ all steps done")

        } catch {
            await disconnect()
            AppLogger.log(.error, category: .bluetooth, "readRegistrySnapshot ❌ failed: \(error)")
            throw error
        }
        

    }
}
