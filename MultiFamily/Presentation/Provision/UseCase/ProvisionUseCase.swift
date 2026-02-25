//
//  ProvisionUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol ProvisionUseCase {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws -> DeviceAddResponseDTO
}


final class ProvisionUseCaseImpl: ProvisionUseCase {
 
    

    
    
    private let repository: ProvisionRepository
    
    init(repository: ProvisionRepository) {
        self.repository = repository
    }

    
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        return try await repository.provision(siteID: siteID, activeMode: activeMode, model: model)
    }
    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws -> DeviceAddResponseDTO {
        return try await repository.submit(siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID, remotePinCode: remotePinCode, bt: bt, attributes: attributes)
    }
}
