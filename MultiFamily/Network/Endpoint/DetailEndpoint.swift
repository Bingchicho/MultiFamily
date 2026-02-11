//
//  DetailEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

enum DetailEndpoint {
    static func registry(_ dto: DetailRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/device-registry/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
