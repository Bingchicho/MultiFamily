//
//  AppAssembler+SiteList.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

extension AppAssembler {
    static func makeSiteListUseCase() -> SiteListUseCase {
        
   
        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()


        let requestFactory = SiteListRequestFactory(
            env: env,
            device: device
        )
        
        

        let repository = SiteListRepositoryImpl(
            apiClient: apiClient,
            siteListFactory: requestFactory
        )


        return SiteListUseCaseImpl(
            repository: repository
        )
    }
}
