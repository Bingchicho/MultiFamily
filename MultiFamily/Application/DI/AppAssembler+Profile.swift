//
//  AppAssembler+Profile.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

extension AppAssembler {
    static func makeProfileUseCase() -> ProfileUseCase {

        let apiClient = URLSessionAPIClient()
        let tokenStore = AppAssembler.tokenStore
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
        let attribute = AppAssembler.userAttributeStore

        let requestFactory = ProfileRequestFactory(
            env: env,
            device: device,
            tokenStore: tokenStore
        )

        let repository = ProfileRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
            userStore: attribute
        )


        return ProfileUseCaseImpl(
            repository: repository
        )
    }
}
