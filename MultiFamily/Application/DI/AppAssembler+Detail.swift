//
//  AppAssembler+Detail.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

extension AppAssembler {
    static func makeDetailUseCase() -> DetailUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = DetailRequestFactory(
            env: env,
            device: device
        )

        let repository = DetailRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
      
        )


        return DetailUseCaseImpl(
            repository: repository
        )
    }
}
