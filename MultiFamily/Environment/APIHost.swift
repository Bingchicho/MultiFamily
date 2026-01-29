//
//  APIHost.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

enum APIHost {
    case api
    case auth

    var baseURL: String {
        switch self {
        case .api:
            return AppEnvironment.apiHostname
        case .auth:
            return AppEnvironment.authService
        }
    }
}
