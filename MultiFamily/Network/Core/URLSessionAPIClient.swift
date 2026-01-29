//
//  URLSessionAPIClient.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

enum APIClientError: Error {
    case invalidResponse
    case httpStatus(code: Int, data: Data)
    case timeout
}

final class URLSessionAPIClient: APIClient {
    
    private let timeout: TimeInterval
    private let authInterceptor: AuthorizationInterceptor?
    
    init(timeout: TimeInterval = 30,
         authInterceptor: AuthorizationInterceptor? = nil) {
        self.timeout = timeout
        self.authInterceptor = authInterceptor
    }
    
    func request<T: Decodable>(_ request: APIRequest) async throws -> T {
        let urlString = request.host.baseURL + request.path
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = timeout
        
        if let interceptor = authInterceptor {
            try await interceptor.adapt(request, urlRequest: &urlRequest)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.httpStatus(code: httpResponse.statusCode, data: data)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let urlError = error as? URLError, urlError.code == .timedOut {
                throw APIClientError.timeout
            }
            throw error
        }
    }
}
