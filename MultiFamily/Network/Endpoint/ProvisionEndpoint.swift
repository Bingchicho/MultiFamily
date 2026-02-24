//
//  DeviceProvisionEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

enum ProvisionEndpoint {
    static func provision(_ dto: ProvisionRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/device-provision",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
