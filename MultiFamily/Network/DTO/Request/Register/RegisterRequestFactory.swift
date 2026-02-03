//
//  RegisterRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//


protocol RegsiterRequestFactoryProtocol {
    func makeRegisterRequest(email: String, password: String, name: String, phone: String?, country: String?) -> RegisterRequestDTO
    
}

struct RegisterRequestFactory: RegsiterRequestFactoryProtocol {
    
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
        
    }
    
    
    func makeRegisterRequest(email: String, password: String, name: String, phone: String?, country: String?) -> RegisterRequestDTO {
        RegisterRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            attribute:
                AttributeDTO(
                    preferredUsername: name,
                    preferredLanguage: "enUS",
                    phone: phone,
                    country: country,
                    debugLog: nil,
                    permission: nil),
            login:
                LoginPayloadDTO(
                    email: email,
                    password: password
                ),
            inviteCode: nil)
    }
    

    
    
}
