//
//  UserEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

enum AuthEndpoint {
    static func login(_ dto: AuthRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/login",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    
    static func refresh(_ dto: AuthRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/login",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    
    static func list(_ dto: applicationIDRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user-list/get",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
}
