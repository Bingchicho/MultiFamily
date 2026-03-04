//
//  SiteListEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

enum SiteEndpoint {
    static func list(_ dto: SiteListRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site-list/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func create(_ dto: SiteCreateRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site/create",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func update(_ dto: SiteUpdateRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site/update",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
    static func delete(_ dto: SiteDeleteRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site/delete",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    
}
