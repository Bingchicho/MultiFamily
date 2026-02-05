//
//  ForgotPasswordSendCodeRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//



protocol ForgotPasswordRequestFactoryProtocol {
    func makeForgotPasswordSendCodeRequestFactory(email: String) -> ForgotPasswordRequestDTO
    func makeForgotPasswordConfirmRequestFactory(ticket: String, code: String, email: String, password: String) -> ForgotPasswordRequestDTO
    
}

struct ForgotPasswordRequestFactory: ForgotPasswordRequestFactoryProtocol {
    
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
        
    }
    
    
    func makeForgotPasswordSendCodeRequestFactory(email: String ) -> ForgotPasswordRequestDTO {
        
        ForgotPasswordRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            login: ForgotPasswordLoginDTO(
                email: email,
                password: nil
            ),
            ticket: nil,
            code: nil
        )
    }
    
    func makeForgotPasswordConfirmRequestFactory(ticket: String, code: String, email: String, password: String) -> ForgotPasswordRequestDTO {
        
        ForgotPasswordRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            login: ForgotPasswordLoginDTO(
                email: email,
                password: password
            ),
            ticket: ticket,
            code: code
        )
    }
    
    
}
