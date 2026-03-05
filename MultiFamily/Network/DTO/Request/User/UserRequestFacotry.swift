//
//  UserRequestFacotry.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//


protocol UserRequestFactoryProtocol {
    func makeUpdateRequest(siteID: String, userID: String, userRole: String) -> SiteUserUpdateRequestDTO
    func makeDeleteRequest(siteID: String, userID: String) -> SiteUserDeleteRequestDTO
}

struct UserRequestFactory: UserRequestFactoryProtocol {

    
 
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider
    ) {
        self.env = env
        self.device = device
        
    }
    
    func makeUpdateRequest(siteID: String, userID: String, userRole: String) -> SiteUserUpdateRequestDTO {
        
        let role = SiteUserRoleDTO(rawValue: userRole)!
        
        return SiteUserUpdateRequestDTO(applicationID: env.applicationID, siteID: siteID, userID: userID, userRole: role, clientToken: device.clientToken)
    }
    
    func makeDeleteRequest(siteID: String, userID: String) -> SiteUserDeleteRequestDTO {
        SiteUserDeleteRequestDTO(applicationID: env.applicationID, siteID: siteID, userID: userID, clientToken: device.clientToken)
    }
    
}
