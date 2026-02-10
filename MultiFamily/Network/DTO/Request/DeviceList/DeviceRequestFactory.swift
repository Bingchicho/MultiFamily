//
//  DeviceRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

protocol DeviceRequestFactoryProtocol {

    func makeDeviceListRequest(siteID: String) -> DeviceListRequestDTO
}

struct DeviceRequestFactory: DeviceRequestFactoryProtocol {

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider

    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
    }

    func makeDeviceListRequest(siteID: String) -> DeviceListRequestDTO {

        DeviceListRequestDTO(
            applicationID: env.applicationID,
            siteID: siteID,
            clientToken: device.clientToken
        )
    }
}
