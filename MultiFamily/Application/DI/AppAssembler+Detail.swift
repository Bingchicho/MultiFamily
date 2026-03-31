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
        let lockunlockservice = AppAssembler.makeLockActionService()


        return DetailUseCaseImpl(
            repository: repository, bleserivce: bleservice, lockunlockservice: lockunlockservice
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
        let bleservice = AppAssembler.makeJobBLEService()

        let repository = DetailRepositoryImpl(
            apiClient: apiClient,
            factory: requestFactory, jobFacotry: jobFactory,
      
        )


        return RegistryUseCaseImpl(
            repository: repository,
            bleserivce: bleservice
        )
    }
}
