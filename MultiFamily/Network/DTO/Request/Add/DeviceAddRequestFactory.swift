//
//  DeviceAddRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

protocol DeviceAddRequestFactoryProtocol {
    
    func makeDeviceAddRequest(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) -> DeviceAddRequestDTO

    
}

struct DeviceAddRequestFactory: DeviceAddRequestFactoryProtocol {
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }
    
    func makeDeviceAddRequest(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) -> DeviceAddRequestDTO {
        DeviceAddRequestDTO(applicationID: env.applicationID, siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID, remotePinCode: remotePinCode, bt: bt, attributes: attributes, clientToken: device.clientToken)
    }
    
}

