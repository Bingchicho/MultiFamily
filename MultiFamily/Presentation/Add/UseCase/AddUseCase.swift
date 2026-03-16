//
//  AddUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//


import MFRBleSDK
import Foundation
protocol AddUseCase {
 
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, Add: ProvisionBLEInfo, form: AddForm ) async throws
}


final class AddUseCaseImpl: AddUseCase {
 
    
    private let repository: AddRepository
    private let bleService: ProvisioningService
    init(repository: AddRepository, bleService: ProvisioningService) {
        self.repository = repository
        self.bleService = bleService
    }


    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, Add: ProvisionBLEInfo, form: AddForm ) async throws  {
        
        try await bleService.provisionAndFetchRegistry(
            btInfo: Add,
            addform: form,
            siteID: siteID
        )
        
        let config = bleService.config
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
                                        direction: config?.lockDirection.letter,
                                        accessCode: config?.password.letter,
                                        preamble: config?.preamble.letter,
                                        twoFA: config?.twoFA.letter,
                                        vacationMode: config?.holidayMode.letter,
                                        autoLock: form.isAutoLockOn ? "T" : "N",
                                        autoLockDelay: form.autoLockDelay,
                                        autoLockDelayMin: Int(config?.autoLockMin ?? 10),
                                        autoLockDelayMax: Int(config?.autoLockMax ?? 120),
                                        operatorVoice: form.isBeepOn ? "T" : "N",
                                        voiceType: config?.soundType?.type,
                                        voiceValue: config?.soundType?.value,
                                        showFastPassageMode: config?.quickPassMode.letter,
                                        sabbathMode: config?.sabbathMode.letter,
                                        voiceLanguage: config?.language?.intValue,
                                        voiceLanguageSupport: config?.supportedLanguages.intValue,
                                        timezone: TimeZone.current.identifier,
                                        mcuVersion: config?.boardVersionString,
                                        bleTXPower: form.txPower.rawValue,
                                        bleAdv: form.adv.rawValue,
                                        battery: status?.batteryLevelInt
                                    ))
        
       
    }
}
