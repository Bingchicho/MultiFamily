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
    func removeDevice(thingName: String) async throws
    func jobList(thingName: String) async throws -> [JobListItemDTO]
    func jobUpdate(jobId: String) async throws
    
}
final class DetailRepositoryImpl: DetailRepository {

    

    

    
    private let apiClient: APIClient
    private let factory: DetailRequestFactoryProtocol
    private let jobFacotry: JobRequestFactoryProtocol
    
    init(
        apiClient: APIClient,
        factory: DetailRequestFactoryProtocol,
        jobFacotry: JobRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.factory = factory
        self.jobFacotry = jobFacotry
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
        
        
        let _: ClientResponseDTO = try await apiClient.request(
            DetailEndpoint.delete(requestDTO)
        )
        
        
    }
    
    func updateRegistry(thingName: String, name: String? , autoLockOn: Bool?, autoLockTime: Int?, beepOn: Bool?, power: Int?, adv: Int?) async throws {
        let requestDTO = factory.makeRegistryUpdateRequest(thingName: thingName, name: name, autoLockOn: autoLockOn, autoLockTime: autoLockTime, beepOn: beepOn, power: power, adv: adv)
        
        let _: RegistryUpdateResponseDTO = try await apiClient.request(DetailEndpoint.update(requestDTO))
        
    }
    
    func removeDevice(thingName: String) async throws {
        
        guard let userId = AppAssembler.userAttributeStore.currentUser?.identityID else { return }
        
        let requestDTO = factory.makePermissionDeleteRequest(thingName: thingName, identityID: userId)
        
        
        let _: ClientResponseDTO = try await apiClient.request(
            PermissionEndpoint.delete(requestDTO)
        )
    }
    
    
    func jobList(thingName: String) async throws -> [JobListItemDTO] {
        let requestDTO = jobFacotry.makeJobListGetRequest(thingName: thingName)
        
        let dto: JobListGetResponseDTO =
        try await apiClient.request(
            JobEndpoint.list(requestDTO)
        )
        
        return dto.jobs
    }
    
    
    func jobUpdate(jobId: String) async throws {
        
        let requestDTO = jobFacotry.makeJobUpdateRequest(jobID: jobId, status: .done)
        
        let _: ClientResponseDTO = try await apiClient.request(
            JobEndpoint.update(requestDTO)
        )
    }
    
}
