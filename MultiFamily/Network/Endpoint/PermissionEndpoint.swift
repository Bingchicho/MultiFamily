//
//  PermissionEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

enum PermissionEndpoint {
    static func get(_ dto: PermissionRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/device-permission/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
