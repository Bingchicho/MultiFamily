//
//  PermissionRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//


protocol PermissionRequestFactoryProtocol {

    func makePermissionRequest(
        thingName: String
    ) -> PermissionRequestDTO

}

struct PermissionRequestFactory: PermissionRequestFactoryProtocol {

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }

    func makePermissionRequest(
        thingName: String
    ) -> PermissionRequestDTO {

        PermissionRequestDTO(applicationID: env.applicationID, thingName: thingName, clientToken: device.clientToken)
    }
}
