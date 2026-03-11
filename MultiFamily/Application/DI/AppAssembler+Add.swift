//
//  AppAssembler+Add.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//

extension AppAssembler {
    static func makeAddUseCase() -> AddUseCase {

        let apiClient = URLSessionAPIClient()
        let tokenStore = AppAssembler.tokenStore
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
  
        let bleService = AppAssembler.makeProvisionBLEService()

        let requestFactory = DeviceAddRequestFactory(
            env: env,
            device: device
        )
  
        

        let repository = AddRepositoryImpl(
            apiClient: apiClient,
            requestFactory: requestFactory
        )


        return AddUseCaseImpl(
            repository: repository, bleService: bleService
        )
    }
    
    

}
