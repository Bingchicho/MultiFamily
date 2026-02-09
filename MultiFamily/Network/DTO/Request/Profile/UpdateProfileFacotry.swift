//
//  UpdateProfileFacotry.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//


protocol UpdateProfileRequestFactoryProtocol {
    func makeNameRequest(name: String) -> UpdateProfileRequestDTO
    func makePasswordRequest(email: String, oldPassword: String, password: String) -> UpdateProfileRequestDTO
    func makeMobileRequest(mobile: String) -> UpdateProfileRequestDTO
}

struct UpdateProfileRequestFactory: UpdateProfileRequestFactoryProtocol {

    

    

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    private let tokenStore: TokenStore
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider,
        tokenStore: TokenStore
    ) {
        self.env = env
        self.device = device
        self.tokenStore = tokenStore
    }
    
    func makeNameRequest(name: String) -> UpdateProfileRequestDTO {
        
         UpdateProfileRequestDTO(applicationID: env.applicationID, attribute: AttributeDTO(preferredUsername: name, preferredLanguage: nil, phone: nil, country: nil, debugLog: true, permission: nil), login: nil, clientToken: device.clientToken)
    }
    
    func makePasswordRequest(email: String, oldPassword: String, password: String) -> UpdateProfileRequestDTO {
        UpdateProfileRequestDTO(applicationID: env.applicationID, attribute: nil, login: UpdateLoginDTO(email: email, oldPassword: oldPassword, password: password), clientToken: device.clientToken)
    }
    
    
    func makeMobileRequest(mobile: String) -> UpdateProfileRequestDTO {
        let name = AppAssembler.userAttributeStore.currentUser?.username ?? "-"
        return UpdateProfileRequestDTO(applicationID: env.applicationID, attribute: AttributeDTO(preferredUsername: name, preferredLanguage: nil, phone: mobile, country: nil, debugLog: nil, permission: nil), login: nil, clientToken: device.clientToken)
    }

   
}
