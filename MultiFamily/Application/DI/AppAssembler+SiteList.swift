//
//  AppAssembler+SiteList.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

extension AppAssembler {
    static func makeSiteUseCase() -> SiteUseCase {
        
   
        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()


        let requestFactory = SiteRequestFactory(
            env: env,
            device: device
        )
        
        

        let repository = SiteRepositoryImpl(
            apiClient: apiClient,
            siteListFactory: requestFactory
        )


        return SiteListUseCaseImpl(
            repository: repository
        )
    }
}
