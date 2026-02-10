//
//  DeviceUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

protocol DeviceUseCase {

    func execute(siteID: String) async -> DeviceListResult
}

final class DeviceUseCaseImpl: DeviceUseCase {

    private let repository: DeviceRepository

    init(repository: DeviceRepository) {
        self.repository = repository
    }

    func execute(siteID: String) async -> DeviceListResult {

        do {

            let devices = try await repository.fetchDevices(siteID: siteID)

            return .success(devices)

        } catch {

            return .failure(
                L10n.Common.Error.network
            )
        }
    }
}
