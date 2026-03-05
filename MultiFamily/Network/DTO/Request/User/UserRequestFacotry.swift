//
//  UserRequestFacotry.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//


protocol UserRequestFactoryProtocol {
    func makeUpdateRequest(siteID: String, userID: String, userRole: UserRole) -> SiteUserUpdateRequestDTO
    func makeDeleteRequest(siteID: String, userID: String) -> SiteUserDeleteRequestDTO
    func makeInviteResendRequest(code: String) -> InviteResendRequestDTO
    func makeInviteDeleteRequest(code: String) -> InviteResendRequestDTO
    func makeInviteUserRequest(email: String, permission: UserPermission) -> InviteUserRequestDTO
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
    
    func makeUpdateRequest(siteID: String, userID: String, userRole: UserRole) -> SiteUserUpdateRequestDTO {
        
        SiteUserUpdateRequestDTO(applicationID: env.applicationID, siteID: siteID, userID: userID, userRole: userRole, clientToken: device.clientToken)
    }
    
    func makeDeleteRequest(siteID: String, userID: String) -> SiteUserDeleteRequestDTO {
        SiteUserDeleteRequestDTO(applicationID: env.applicationID, siteID: siteID, userID: userID, clientToken: device.clientToken)
    }
    
    func makeInviteResendRequest(code: String) -> InviteResendRequestDTO {
        InviteResendRequestDTO(applicationID: env.applicationID, inviteCode: code, clientToken: device.clientToken)
    }
    
    func makeInviteDeleteRequest(code: String) -> InviteResendRequestDTO {
        InviteResendRequestDTO(applicationID: env.applicationID, inviteCode: code, clientToken: device.clientToken)
    }
    
    
    func makeInviteUserRequest(email: String, permission: UserPermission) -> InviteUserRequestDTO {
        InviteUserRequestDTO(applicationID: env.applicationID, email: email, permission: [permission], clientToken: device.clientToken)
    }
}
