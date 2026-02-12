//
//  HistoryRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

protocol HistoryRequestFactoryProtocol {

    func makeHistoryRequest(
        id: String,
        timePoint: Int64,
        maximum: Int
    ) -> HistoryRequestDTO

}

struct HistoryRequestFactory: HistoryRequestFactoryProtocol {

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }

    func makeHistoryRequest(
        id: String,
        timePoint: Int64,
        maximum: Int
    ) -> HistoryRequestDTO {

        HistoryRequestDTO(
            applicationID: env.applicationID,
            id: id,
            idType: "device",
            timePoint: timePoint,
            maximum: maximum,
            clientToken: device.clientToken
        )
    }
}
