//
//  AppAssembler+Provision.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

extension AppAssembler {
    static func makeProvisionUseCase() -> ProvisionUseCase {

        let apiClient = URLSessionAPIClient()
        let tokenStore = AppAssembler.tokenStore
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
        let attribute = AppAssembler.userAttributeStore

        let requestFactory = ProvisionRequestFactory(
            env: env,
            device: device
        )

        let repository = ProvisionRepositoryImpl(
            apiClient: apiClient,
            requestFactory: requestFactory
        )


        return ProvisionUseCaseImpl(
            repository: repository
        )
    }
    
    

}
