//
//  ProvisionUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

import MFRBleSDK
protocol ProvisionUseCase {
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO

}


final class ProvisionUseCaseImpl: ProvisionUseCase {
 
    
    private let repository: ProvisionRepository
    private let bleService: BLEService
    init(repository: ProvisionRepository, bleService: BLEService) {
        self.repository = repository
        self.bleService = bleService
    }

    
    func provision(siteID: String, activeMode: ActiveModeDTO, model: String) async throws -> ProvisionResponseDTO {
        let response =  try await repository.provision(siteID: siteID, activeMode: activeMode, model: model)
        try await bleService.connection()
        return response
    }
    
  
}
