//
//  UserEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

enum UserEndpoint {
    static func login(_ dto: UserRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/login",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    
    static func refresh(_ dto: UserRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/login",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    
}
