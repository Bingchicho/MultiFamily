//
//  DetailRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailRequestFactoryProtocol {

    func makeDetailRequest(thingName: String) -> DetailRequestDTO

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

}
