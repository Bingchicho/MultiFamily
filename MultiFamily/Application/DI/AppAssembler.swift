//
//  AppAssembler.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

final class AppAssembler {

    static func makeLoginUseCase() -> LoginUseCase {

        let apiClient = URLSessionAPIClient()
        let tokenStore = DefaultTokenStore()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
        let attribute = DefaultUserAttributeStore()

        let requestFactory = UserRequestFactory(
            env: env,
            device: device,
            tokenStore: tokenStore
        )

        let repository = UserRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore,
            userRequestFactory: requestFactory,
            userAttribute: attribute
        )


        return LoginUseCaseImpl(
            repository: repository
        )
    }
    
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
