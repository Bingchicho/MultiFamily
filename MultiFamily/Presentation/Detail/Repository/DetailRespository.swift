//
//  DetailRespository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailRepository {

    func fetchRegistry(thingName: String) async throws -> Detail
    func deleteDevice(thingName: String) async throws

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
    
    func fetchRegistry(thingName: String) async throws -> Detail {
        let requestDTO = factory.makeDetailRequest(thingName: thingName)
        
        let dto: DetailResponseDTO =
            try await apiClient.request(
                DetailEndpoint.registry(requestDTO)
            )
        
        return dto.toDomain()
    }
    
    func deleteDevice(thingName: String) async throws {

            let requestDTO = factory.makeDeleteDeviceRequest(
                thingName: thingName
            )

       
        let dto: ClientResponseDTO = try await apiClient.request(
                DetailEndpoint.delete(requestDTO)
            )

        
        }
    
}
