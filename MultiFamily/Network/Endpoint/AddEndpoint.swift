//
//  AddEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/25.
//

enum AddEndpoint {
    static func deviceAdd(_ dto: DeviceAddRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/device/add",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
