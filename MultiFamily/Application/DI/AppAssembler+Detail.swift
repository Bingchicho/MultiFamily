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
        
        let jobFactory = JobRequestFactory(env: env, device: device)

        let repository = DetailRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory,
            jobFacotry: jobFactory,
      
        )
        
        let bleservice = AppAssembler.makeJobBLEService()


        return DetailUseCaseImpl(
            repository: repository, bleserivce: bleservice
        )
    }
    
    static func makeRegistryUseCase() -> RegistryUseCase {

        let apiClient = URLSessionAPIClient()
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = DetailRequestFactory(
            env: env,
            device: device
        )
        
        let jobFactory = JobRequestFactory(env: env, device: device)

        let repository = DetailRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory, jobFacotry: jobFactory,
      
        )


        return RegistryUseCaseImpl(
            repository: repository
        )
    }
}
