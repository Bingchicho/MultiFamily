//
//  SiteListEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

enum SiteEndpoint {
    static func getList(_ dto: SiteListRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/site-list/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
    

    
}
