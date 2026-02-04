//
//  AppAssembler+RegisterVerify.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

extension AppAssembler {
    static func makeRegisterVerifyUseCase() -> RegisterVerifyUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = RegisterVerifyRequestFactory(
            device: device
        )
        
        let verifyFactory = VerifyResendRequestFactory(env: env, device: device)

        let repository = RegisterVerifyRepositoryImpl(
            apiClient: apiClient,
            registerVerifyFactory: requestFactory,
            verifyResendFactory: verifyFactory,
      
        )


        return RegisterVerifyUseCaseImpl(
            repository: repository
        )
    }
}
