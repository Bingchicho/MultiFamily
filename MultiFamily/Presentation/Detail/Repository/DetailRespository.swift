//
//  DetailRespository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailRepository {
    
    func fetchRegistry(thingName: String) async throws -> DetailResponseDTO
    func deleteDevice(thingName: String) async throws
    func updateRegistry(thingName: String, name: String? ,autoLockOn: Bool?, autoLockTime: Int?, beepOn: Bool?, power: Int?, adv: Int?) async throws
    
}
final class DetailRepositoryImpl: DetailRepository {
    
    private let apiClient: APIClient
    private let factory: DetailRequestFactoryProtocol
    
    init(
        apiClient: APIClient,
        factory: DetailRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.factory = factory
    }
    
    func fetchRegistry(thingName: String) async throws -> DetailResponseDTO {
        let requestDTO = factory.makeDetailRequest(thingName: thingName)
        
        let dto: DetailResponseDTO =
        try await apiClient.request(
            DetailEndpoint.registry(requestDTO)
        )
        
        return dto
    }
    
    func deleteDevice(thingName: String) async throws {
        
        let requestDTO = factory.makeDeleteDeviceRequest(
            thingName: thingName
        )
        
        
        let dto: ClientResponseDTO = try await apiClient.request(
            DetailEndpoint.delete(requestDTO)
        )
        
        
    }
    
    func updateRegistry(thingName: String, name: String? , autoLockOn: Bool?, autoLockTime: Int?, beepOn: Bool?, power: Int?, adv: Int?) async throws {
        let requestDTO = factory.makeRegistryUpdateRequest(thingName: thingName, name: name, autoLockOn: autoLockOn, autoLockTime: autoLockTime, beepOn: beepOn, power: power, adv: adv)
        
        let dto: RegistryUpdateResponseDTO = try await apiClient.request(DetailEndpoint.update(requestDTO))
        
        
        
    }
    
    
}
