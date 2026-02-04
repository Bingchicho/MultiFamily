//
//  VerifyResendRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//


protocol VerifyResendRequestFactoryProtocol {
    func makeVerifyResendRequest(email: String) -> VerifyResendRequestDTO
    
}

struct VerifyResendRequestFactory: VerifyResendRequestFactoryProtocol {

    
    
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
        
    }
    
    
    func makeVerifyResendRequest(email: String) -> VerifyResendRequestDTO {
        VerifyResendRequestDTO(
            applicationID: env.applicationID,
            login: VerifyResendLoginDTO(email: email),
            verifyRequiredAction: .email,
            clientToken: device.clientToken
            
        )
    }
    
 
    

    
    
}
