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
    public private(set) var status: LockStatus?
    public private(set) var config: LockConfig?
    
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
    
    private func sdkGetStatus() async throws{
        try await withCheckedThrowingContinuation { continuation in
            sdk.queryLockStatus { result in
                switch result {
                case .success(let status):
                    
                    self.status = status
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
            
            try await sdkGetStatus()
            
            // ✅ Only reach here means ALL steps succeeded
            AppLogger.log(.info, category: .bluetooth, "readRegistrySnapshot ✅ all steps done")
            
        } catch {
            await disconnect()
            AppLogger.log(.error, category: .bluetooth, "readRegistrySnapshot ❌ failed: \(error)")
            throw error
        }
        
        
    }
    
    private func sdkGetConfig() async throws{
        try await withCheckedThrowingContinuation { continuation in
            sdk.queryLockConfig() { result in
                switch result {
                case .success(let config):
                    self.config = config
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func sdkUpdateConfig(value: JobSettingDTO) async throws{
        guard let config else {
            return
        }
        
        var payload = RequestLockConfig(from: config)
        // mapping payload
        value.patches.forEach { patch in
            switch patch {
            case .location(let value):
                break
            case .direction(let value):
                break
            case .accessCode(let value):
                break
            case .preamble(let value):
                payload.preamble = value == "Y" ? .on : .off
            case .virtualCode(let value):
                break
            case .twoFA(let value):
                payload.twoFA =  value == "Y" ? .on : .off
            case .vacationMode(let value):
                payload.holidayMode =  value == "Y" ? .on : .off
            case .autoLock(let value):
                payload.autoLock =  value == "Y" ? .on : .off
            case .autoLockDelay(let value):
                payload.autoLockTimeSeconds = value
            case .autoLockDelayMin(let value):
                break
            case .autoLockDelayMax(let value):
                break
            case .operatorVoice(let value):
                payload.sound =  value == "Y" ? .on : .off
            case .voiceType(let v1, let v2):
                var typeValue: SoundType = .onOff(enabled: true)
                if v1 == 2 {
                    typeValue = .level(v2)
                }
                
                if v1 == 3 {
                    typeValue = .percent(v2)
                }
                payload.soundType = typeValue
                
            case .showFastPassageMode(let value):
                payload.quickPassMode = value == "Y" ? .on : .off
            case .sabbathMode(let value):
                payload.sabbathMode = value == "Y" ? .on : .off
            case .voiceLanguage(let value):
                break
            case .voiceLanguageSupport(let value):
                break
            case .timezone(let value):
                break
            case .mcuVersion:
                break
            case .bleTXPower(let value):
                payload.bleTxPower = value
            case .bleAdv(let value):
                payload.bleAdvInterval = value
            case .battery:
                break
            }
        }
        
        
        try await withCheckedThrowingContinuation { continuation in
            sdk.updateLockConfig(payload: payload) { result in
                switch result {
                case .success(let config):
                    
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func setupSetting(value: JobSettingDTO) async throws {
        guard isConnected else {
            throw NSError(domain: "BLE", code: -1, userInfo: [NSLocalizedDescriptionKey: "BLE not connected"])
        }
        
        
        do {
            // 1)
            try await sdkGetConfig()
            
            // 2)
            try await sdkUpdateConfig(value: value)
            
            
            // ✅ Only reach here means ALL steps succeeded
            AppLogger.log(.info, category: .bluetooth, "UpdateConfig ✅ all steps done")
            
        } catch {
            await disconnect()
            AppLogger.log(.error, category: .bluetooth, "UpdateConfig ❌ failed: \(error)")
            throw error
        }
    }
}
