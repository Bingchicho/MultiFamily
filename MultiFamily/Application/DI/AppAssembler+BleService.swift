//
//  AppAssembler+BleService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

extension AppAssembler {

    /// Shared BLE service instance so multiple pages / use cases reuse the same BLE connection
    private static let sharedBLEService: BLEService = {

        // 1️⃣ 建立底層 BLE Client（唯一 import MFRBleSDK 的實作）
        let bleClient: BleClient = MFRBleClient()

        // 2️⃣ 建立 Provision 流程 Service（只負責流程，不碰 SDK）
        let bleService = BleProvisioningService(client: bleClient)

        return bleService
    }()

    static func makeBLEService() -> BLEService {
        return sharedBLEService
    }
}
