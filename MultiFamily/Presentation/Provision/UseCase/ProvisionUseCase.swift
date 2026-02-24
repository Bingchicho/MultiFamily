//
//  ProvisionUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol ProvisionUseCase {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO
}


final class ProvisionUseCaseImpl: ProvisionUseCase {

    
    
    private let repository: ProvisionRepository
    
    init(repository: ProvisionRepository) {
        self.repository = repository
    }

    
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        return try await repository.provision(siteID: siteID, activeMode: activeMode, model: model)
    }
}
