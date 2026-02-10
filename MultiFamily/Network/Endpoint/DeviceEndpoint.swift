//
//  DeviceEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

enum DeviceEndpoint {
    static func list(_ dto: DeviceListRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/device-list/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
