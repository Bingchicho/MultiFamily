//
//  AppAssembler+DeviceList.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

extension AppAssembler {
    static func makeDeviceUseCase() -> DeviceUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = DeviceRequestFactory(
            env: env,
            device: device
        )

        let repository = DeviceRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
      
        )


        return DeviceUseCaseImpl(
            repository: repository
        )
    }
}
