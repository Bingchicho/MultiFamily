//
//  AppAssembler+Permission.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//



extension AppAssembler {
    static func makePermissionUseCase() -> PermissionUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = PermissionRequestFactory(
            env: env,
            device: device
        )

        let repository = PermissionRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
      
        )

        return PermissionUseCaseImpl(
            repository: repository
        )
    }
}
