//
//  AppAssembler+RegisterVerify.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

extension AppAssembler {
    static func makeRegisterVerifyUseCase() -> RegisterVerifyUseCase {

        let apiClient = URLSessionAPIClient()

        let device = DefaultDeviceIdentifierProvider()

        let requestFactory = RegisterVerifyRequestFactory(
            device: device
        )

        let repository = RegisterVerifyRepositoryImpl(
            apiClient: apiClient,
            registerVerifyFactory: requestFactory,
      
        )


        return RegisterVerifyUseCaseImpl(
            repository: repository
        )
    }
}
