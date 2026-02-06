//
//  SiteListRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

protocol SiteListRequestFactoryProtocol {
    func makeSiteListRequest() -> SiteListRequestDTO
    
}

struct SiteListRequestFactory: SiteListRequestFactoryProtocol {

    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
        
    }
    
    
    func makeSiteListRequest() -> SiteListRequestDTO {
        SiteListRequestDTO(applicationID: env.applicationID, clientToken: device.clientToken)
    }
    
 
    

    
    
}
