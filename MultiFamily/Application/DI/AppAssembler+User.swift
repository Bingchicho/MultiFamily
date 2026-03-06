//
//  AppAssembler+User.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/6.
//

extension AppAssembler {
    static func makeUserUseCase() -> UserUseCase {
        let apiClient = URLSessionAPIClient()
  
        let env = DefaultEnvironmentConfig()
        let device = DefaultDeviceIdentifierProvider()
        
  

        let requestFactory = UserRequestFactory(
            env: env,
            device: device
        )

        let applicationFactory = applicationIDRequestFactory(env: env, device: device)
        

        let repository = UserRepositoryImpl(
            apiClient: apiClient,
            userRequestFactory: requestFactory, applicationFactory: applicationFactory

        )


        return UserUseCaseImpl(
            repository: repository
        )
    }
}
