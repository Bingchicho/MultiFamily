//
//  AppAssembler+ForgotPassword.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

extension AppAssembler {
    static func makeForgotPasswordUseCase() -> ForgotPasswordUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = ForgotPasswordRequestFactory(
            env: env,
            device: device
        )

        let repository = ForgotPasswordRepositoryImpl(
            apiClient: apiClient,
            requestFactory: requestFactory,
      
        )


        return ForgotPasswordUseCaseImpl(
            repository: repository
        )
    }
}
