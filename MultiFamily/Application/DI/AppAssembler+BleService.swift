//
//  AppAssembler+BleService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

extension AppAssembler {

    /// Shared BLE service instance so multiple pages / use cases reuse the same BLE connection
    private static let sharedProvisionBLEService: ProvisioningService = {

        // 1️⃣ 建立底層 BLE Client（唯一 import MFRBleSDK 的實作）
        let bleClient: BleClient = MFRBleClient()

        // 2️⃣ 建立 Provision 流程 Service（只負責流程，不碰 SDK）
        let bleService = BleProvisioningService(client: bleClient)

        return bleService
    }()
    
    private static let sharedConfigBLEService: JobService = {

        // 1️⃣ 建立底層 BLE Client（唯一 import MFRBleSDK 的實作）
        let bleClient: BleClient = MFRBleClient()

        // 2️⃣ 建立 Provision 流程 Service（只負責流程，不碰 SDK）
        let bleService = BleConfigService(client: bleClient)

        return bleService
    }()
    
    private static let sharedLockUnlockActionBLEService: LockUnlockService = {

        // 1️⃣ 建立底層 BLE Client（唯一 import MFRBleSDK 的實作）
        let bleClient: BleClient = MFRBleClient()

        // 2️⃣ 建立 Provision 流程 Service（只負責流程，不碰 SDK）
        let bleService = BleLockUnlockService(client: bleClient)

        return bleService
    }()

    static func makeProvisionBLEService() -> ProvisioningService {
        return sharedProvisionBLEService
    }
    
    static func makeJobBLEService() -> JobService {
        return sharedConfigBLEService
    }
    
    static func makeLockActionService() -> LockUnlockService {
        return sharedLockUnlockActionBLEService
    }
    
}
