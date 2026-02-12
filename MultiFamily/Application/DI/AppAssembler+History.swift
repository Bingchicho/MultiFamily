//
//  AppAssembler+History.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//


extension AppAssembler {
    static func makeHistoryUseCase() -> HistoryUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = HistoryRequestFactory(
            env: env,
            device: device
        )

        let repository = HistoryRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
      
        )


        return HistoryUseCaseImpl(
            repository: repository
        )
    }
}
