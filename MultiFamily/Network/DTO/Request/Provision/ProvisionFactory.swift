//
//  ProvisionFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol ProvisionRequestFactoryProtocol {

    func makeProvisionRequest(
        siteID: String, activeMode: ActiveModeDTO, model: String
    ) -> ProvisionRequestDTO

}

struct ProvisionRequestFactory: ProvisionRequestFactoryProtocol {

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }

    func makeProvisionRequest(
        siteID: String, activeMode: ActiveModeDTO, model: String
    ) -> ProvisionRequestDTO {

        ProvisionRequestDTO(applicationID: env.applicationID, siteID: siteID, activeMode: activeMode, model: model, clientToken: device.clientToken)
    }
}
