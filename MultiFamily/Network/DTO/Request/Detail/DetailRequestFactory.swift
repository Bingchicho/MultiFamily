//
//  DetailRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailRequestFactoryProtocol {
    
    func makeDetailRequest(thingName: String) -> DetailRequestDTO
    func makeDeleteDeviceRequest(thingName: String) -> DeleteDeviceRequestDTO
    func makeRegistryUpdateRequest(thingName: String, name: String?, autoLockOn: Bool?, autoLockTime: Int?, beepOn: Bool?, power: Int?, adv: Int?) -> RegistryUpdateRequestDTO
    
}

struct DetailRequestFactory: DetailRequestFactoryProtocol {
    
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }
    
    func makeDetailRequest(thingName: String) -> DetailRequestDTO {
        
        DetailRequestDTO(
            applicationID: env.applicationID,
            thingName: thingName,
            clientToken: device.clientToken
        )
    }
    
    func makeDeleteDeviceRequest(thingName: String) -> DeleteDeviceRequestDTO {
        
        DeleteDeviceRequestDTO(
            applicationID: env.applicationID,
            thingName: thingName,
            clientToken: device.clientToken
        )
    }
    
    func makeRegistryUpdateRequest(thingName: String, name: String?, autoLockOn: Bool?, autoLockTime: Int?, beepOn: Bool?, power: Int?, adv: Int?) -> RegistryUpdateRequestDTO {
        RegistryUpdateRequestDTO(applicationID: env.applicationID, thingName: thingName, clientToken: device.clientToken, overwrite: nil, taskID: device.clientToken, status: "started", userName: nil, name: name, installationNotComplete: nil, bt: nil, attributes: DeviceAttributesDTO(location: nil, direction: nil, accessCode: nil, preamble: nil, virtualCode: nil, twoFA: nil, vacationMode: nil, autoLock: autoLockOn ?? false ? "Y": "N", autoLockDelay: autoLockTime, autoLockDelayMin: nil, autoLockDelayMax: nil, operatorVoice: beepOn ?? false ? "Y" : "N", voiceType: nil, voiceValue: nil, showFastPassageMode: nil, sabbathMode: nil, voiceLanguage: nil, voiceLanguageSupport: nil, timezone: nil, mcuVersion: nil, bleTXPower: power, bleAdv: adv, battery: nil, updateAt: nil))
    }
    
}
