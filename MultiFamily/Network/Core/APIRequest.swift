//
//  APIRequest.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct APIRequest {
    let host: APIHost
    let path: String
    let method: HTTPMethod
    let body: Encodable?
    let requiresAuth: Bool

    init(
        host: APIHost,
        path: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        requiresAuth: Bool = true   // ⭐ 預設要授權
    ) {
        self.host = host
        self.path = path
        self.method = method
        self.body = body
        self.requiresAuth = requiresAuth
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
