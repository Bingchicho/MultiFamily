//
//  ProvisionRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol ProvisionRepository {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws
}


final class ProvisionRepositoryImpl: ProvisionRepository {

    private let apiClient: APIClient
    
    private let requestFactory: ProvisionRequestFactoryProtocol
    private let factory: DeviceAddRequestFactoryProtocol

    init(apiClient: APIClient,  requestFactory: ProvisionRequestFactoryProtocol, factory: DeviceAddRequestFactoryProtocol) {
        self.apiClient = apiClient
        self.requestFactory = requestFactory
        self.factory = factory
    }

    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        
        let requestDTO = requestFactory.makeProvisionRequest(siteID: siteID, activeMode: activeMode, model: model)
        
        let response: ProvisionResponseDTO = try await apiClient.request(
            ProvisionEndpoint.provision(requestDTO)
        )
        
        return response
    
    }
    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws  {
        let requestDTO = factory.makeDeviceAddRequest(siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID, remotePinCode: remotePinCode, bt: bt, attributes: attributes)
        
        let dto: DeviceAddResponseDTO =
        try await apiClient.request(
            AddEndpoint.deviceAdd(requestDTO)
        )
        
       
    }
}
