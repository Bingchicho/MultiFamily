//
//  applicationIDRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//


protocol applicationIDRequestFactoryProtocol {
    func makeapplicationIDRequest() -> applicationIDRequestDTO

}

struct applicationIDRequestFactory: applicationIDRequestFactoryProtocol {

    

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
   
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
    
    }
    
    func makeapplicationIDRequest() -> applicationIDRequestDTO {
        applicationIDRequestDTO(applicationID: env.applicationID, clientToken: device.clientToken)
    }
    
 
   
}
