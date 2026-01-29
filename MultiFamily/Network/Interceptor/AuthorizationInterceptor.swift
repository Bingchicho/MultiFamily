//
//  AuthorizationInterceptor.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

struct AuthorizationInterceptor {

    let tokenProvider: () async throws -> String?

    func adapt(
        _ apiRequest: APIRequest,
        urlRequest: inout URLRequest
    ) async throws {

        guard apiRequest.requiresAuth else { return }
        guard let token = try await tokenProvider() else { return }

        urlRequest.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
    }
}
