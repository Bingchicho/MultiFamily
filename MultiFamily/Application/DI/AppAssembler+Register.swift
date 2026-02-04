//
//  AppAssembler+Register.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

extension AppAssembler {
    static func makeRegisterUseCase() -> RegisterUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = RegisterRequestFactory(
            env: env,
            device: device
        )

        let repository = RegisterRepositoryImpl(
            apiClient: apiClient,
            requestFactory: requestFactory,
      
        )


        return RegisterUseCaseImpl(
            repository: repository
        )
    }
}
