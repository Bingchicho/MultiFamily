//
//  JobEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

enum JobEndpoint {
    static func get(_ dto: JobGetRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/job/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    static func create(_ dto: JobCreateRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/job/create",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func update(_ dto: JobUpdateRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/job/update",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }

}
