//
//  UserEndpoing.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//


enum UserEndpoint {
    
    static func list(_ dto: applicationIDRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user-list/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func update(_ dto: SiteUserUpdateRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site-user/update",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func delete(_ dto: SiteUserDeleteRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site-user/delete",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func inviteResend(_ dto: InviteResendRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/invite-user/resend",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func inviteDelete(_ dto: InviteResendRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/invite-user/delete",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func inviteUser(_ dto: InviteUserRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/invite-user/create",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
