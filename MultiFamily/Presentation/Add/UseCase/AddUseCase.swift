//
//  AddUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//


import MFRBleSDK
protocol AddUseCase {
 
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, Add: ProvisionBLEInfo, form: AddForm ) async throws
}


final class AddUseCaseImpl: AddUseCase {
 
    
    private let repository: AddRepository
    private let bleService: BLEService
    init(repository: AddRepository, bleService: BLEService) {
        self.repository = repository
        self.bleService = bleService
    }


    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, Add: ProvisionBLEInfo, form: AddForm ) async throws  {
        
        try await bleService.provisionAndFetchRegistry(
            btInfo: Add,
            addform: form,
            siteID: siteID
        )
        
        let status = bleService.status
        
        try await repository.submit(siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID,
                                    remotePinCode: Add.remotePinCode,
                                    bt: DeviceAddBTRequestDTO(
                                        uuid: Add.uuid,
                                        key: Add.key,
                                        token: Add.token,
                                        iv: Add.iv
                                    ),
                                    attributes: DeviceAddAttributesDTO(
                                        autoLock: form.isAutoLockOn ? "Y" : "N",
                                        autoLockDelay: form.autoLockDelay,
                                        operatorVoice: form.isBeepOn ? "Y" : "N",
                                        mcuVersion: status?.boardVersionString,
                                        bleTXPower: form.txPower.rawValue,
                                        bleAdv: form.adv.rawValue,
                                        battery: status?.batteryLevelInt
                                    ))
    }
}
