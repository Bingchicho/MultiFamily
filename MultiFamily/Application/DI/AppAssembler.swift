//
//  AppAssembler.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

final class AppAssembler {

    static func makeLoginUseCase() -> LoginUseCase {

        let apiClient = URLSessionAPIClient()
        let tokenStore = AppAssembler.tokenStore
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
        let attribute = AppAssembler.userAttributeStore

        let requestFactory = AuthRequestFactory(
            env: env,
            device: device,
            tokenStore: tokenStore
        )

        let repository = AuthRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore,
            userRequestFactory: requestFactory,
            userAttribute: attribute
        )


        return LoginUseCaseImpl(
            repository: repository
        )
    }
    
    
}
