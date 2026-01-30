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
        let urlString = request.host + request.version + request.path
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        print("🌐 Request URL =", urlString)
        if let body = request.body {
            print("📦 Request body JSON:\n", body.toJSONString() ?? "nil")
        } else {
            print("📦 Request body = nil")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = timeout
        
        if let interceptor = authInterceptor {
            try await interceptor.adapt(request, urlRequest: &urlRequest)
        }
        print("🧾 Request Headers:")
        urlRequest.allHTTPHeaderFields?.forEach { key, value in
            print("  \(key): \(value)")
        }

        if let bodyData = urlRequest.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 HTTP Body:\n\(bodyString)")
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📥 Response Status Code:", httpResponse.statusCode)
            }

            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
               let jsonString = String(data: prettyData, encoding: .utf8) {
                print("📦 Response JSON:\n\(jsonString)")
            } else if let rawString = String(data: data, encoding: .utf8) {
                print("📦 Response Raw:\n\(rawString)")
            }
            
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
