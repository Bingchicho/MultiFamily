//
//  ForgotPasswordSendCodeRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//



protocol ForgotPasswordRequestFactoryProtocol {
    func makeForgotPasswordSendCodeRequestFactory(email: String) -> ForgotPasswordSendCodeRequestDTO
    func makeForgotPasswordConfirmRequestFactory(ticket: String, code: String, email: String, password: String) -> ForgotPasswordConfirmRequestDTO
    
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
    
    
    func makeForgotPasswordSendCodeRequestFactory(email: String ) -> ForgotPasswordSendCodeRequestDTO {
        ForgotPasswordSendCodeRequestDTO(
            applicationID: env.applicationID,
            login:
                LoginEmailDTO(email: email),
            clientToken: device.clientToken)
    }
    
    func makeForgotPasswordConfirmRequestFactory(ticket: String, code: String, email: String, password: String) -> ForgotPasswordConfirmRequestDTO {
        
        ForgotPasswordConfirmRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            ticket: ticket,
            code: code,
            login:
                LoginPayloadDTO(email: email, password: password))
    }
    
    
}
