//
//  ProvisionUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

import MFRBleSDK
protocol ProvisionUseCase {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, provision: ProvisionBLEInfo, form: AddForm ) async throws
}


final class ProvisionUseCaseImpl: ProvisionUseCase {
 
    
    private let repository: ProvisionRepository
    private let bleService: BLEService
    init(repository: ProvisionRepository, bleService: BLEService) {
        self.repository = repository
        self.bleService = bleService
    }

    
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        let response =  try await repository.provision(siteID: siteID, activeMode: activeMode, model: model)
        try await bleService.connection()
        return response
    }
    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, provision: ProvisionBLEInfo, form: AddForm ) async throws  {
        
        try await bleService.provisionAndFetchRegistry(
            btInfo: provision,
            addform: form,
            siteID: siteID
        )
        
        let status = bleService.status
        
        try await repository.submit(siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID,
                                    remotePinCode: provision.remotePinCode,
                                    bt: DeviceAddBTRequestDTO(
                                        uuid: provision.uuid,
                                        key: provision.key,
                                        token: provision.token,
                                        iv: provision.iv
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
