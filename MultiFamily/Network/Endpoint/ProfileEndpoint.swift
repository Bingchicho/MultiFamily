//
//  ProfileEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

enum ProfileEndpoint {
    static func update(_ dto: UpdateProfileRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/update",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    
    static func logout(_ dto: LogoutRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/logout",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
}
