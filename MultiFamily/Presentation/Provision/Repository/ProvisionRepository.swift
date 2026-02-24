//
//  ProvisionRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol ProvisionRepository {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO
}


final class ProvisionRepositoryImpl: ProvisionRepository {

    private let apiClient: APIClient
    
    private let requestFactory: ProvisionRequestFactoryProtocol

    init(apiClient: APIClient,  requestFactory: ProvisionRequestFactoryProtocol) {
        self.apiClient = apiClient
        self.requestFactory = requestFactory
    }

    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        
        let requestDTO = requestFactory.makeProvisionRequest(siteID: siteID, activeMode: activeMode, model: model)
        
        let response: ProvisionResponseDTO = try await apiClient.request(
            ProvisionEndpoint.provision(requestDTO)
        )
        
        return response
    
    }
}
