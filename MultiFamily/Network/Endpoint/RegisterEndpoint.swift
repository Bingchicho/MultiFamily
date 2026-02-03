//
//  RegisterEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

enum RegisterEndpoint {
    static func create(_ dto: RegisterRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/create",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    

    
}
