//
//  APIClient.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

protocol APIClient {
    func request<T: Decodable>(_ request: APIRequest) async throws -> T
}
