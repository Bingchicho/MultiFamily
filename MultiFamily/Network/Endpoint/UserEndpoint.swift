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
            requiresAuth: false
        )
    }
}
