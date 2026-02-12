//
//  PermissionRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

protocol PermissionRepository {

    func fetchPermission(
        thingName: String
    ) async throws -> PermissionResponseDTO
}
final class PermissionRepositoryImpl: PermissionRepository {

    private let apiClient: APIClient
    private let factory: PermissionRequestFactoryProtocol

    init(
        apiClient: APIClient,
        factory: PermissionRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.factory = factory
    }

    func fetchPermission(
        thingName: String
    ) async throws -> PermissionResponseDTO {

        let dto = factory.makePermissionRequest(
            thingName: thingName
        )

        let request = PermissionEndpoint.get(dto)
        let response: PermissionResponseDTO = try await apiClient.request(request)
        
        return response
    }
}
