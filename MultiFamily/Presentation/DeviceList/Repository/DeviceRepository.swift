//
//  DeviceRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

import Foundation
protocol DeviceRepository {

    func fetchDevices(siteID: String) async throws -> [Device]

}
final class DeviceRepositoryImpl: DeviceRepository {

    private let apiClient: APIClient
    private let factory: DeviceRequestFactoryProtocol

    init(
        apiClient: APIClient,
        factory: DeviceRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.factory = factory
    }

    func fetchDevices(siteID: String) async throws -> [Device] {

        let requestDTO = factory.makeDeviceListRequest(siteID: siteID)

        let dto: DeviceListResponseDTO =
            try await apiClient.request(
                DeviceEndpoint.list(requestDTO)
            )

        return dto.devices
            .map { $0.toDomain() }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
