//
//  SiteRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

protocol SiteRequestFactoryProtocol {
    func makeSiteListRequest() -> SiteListRequestDTO
    func makeSiteCreateRequest(name: String) -> SiteCreateRequestDTO
    func makeSiteUpdateRequest(_ id: String,name: String) -> SiteUpdateRequestDTO
    func makeSiteDeleteRequest(_ id: String) -> SiteDeleteRequestDTO
}

struct SiteRequestFactory: SiteRequestFactoryProtocol {


    
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
    
 
    
    func makeSiteCreateRequest(name: String) -> SiteCreateRequestDTO {
        SiteCreateRequestDTO(applicationID: env.applicationID, name: name, clientToken: device.clientToken)
    }
    
    func makeSiteUpdateRequest(_ id: String, name: String) -> SiteUpdateRequestDTO {
        SiteUpdateRequestDTO(applicationID: env.applicationID, siteID: id, name: name, clientToken: device.clientToken)
    }
    
    func makeSiteDeleteRequest(_ id: String) -> SiteDeleteRequestDTO {
        SiteDeleteRequestDTO(applicationID: env.applicationID, siteID: id, clientToken: device.clientToken)
    }
}
