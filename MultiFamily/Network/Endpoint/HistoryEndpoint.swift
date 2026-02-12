//
//  HistoryEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

enum HistoryEndpoint {
    static func history(_ dto: HistoryRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/activity-log/get",
            method: .post,
            body: dto,
            requiresAuth: true
        )
    }
}
