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
        AppLogger.log(.info, category: .network, "🌐 Request URL = \(urlString)")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = timeout
 
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = request.body {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(AnyEncodable(body))
                urlRequest.httpBody = data
            } catch {
                AppLogger.log(.error, category: .network, "❌ Failed to encode request body: \(error)")
                throw error
            }
        }
        
        if let interceptor = authInterceptor {
            try await interceptor.adapt(request, urlRequest: &urlRequest)
        }

        logRequest(urlRequest)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            logResponse(data: data, response: response)
            
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
    
    
    private func logRequest(_ request: URLRequest) {
        AppLogger.log(.info, category: .network, "🧾 Request Headers:")
        request.allHTTPHeaderFields?.forEach {
            AppLogger.log(.info, category: .network, "  \($0): \($1)")
        }

        if let body = request.httpBody,
           let string = String(data: body, encoding: .utf8) {
            AppLogger.log(.info, category: .network, "📤 HTTP Body:\n\(string)")
        }
    }

    private func logResponse(data: Data, response: URLResponse) {

        if let http = response as? HTTPURLResponse {
            AppLogger.log(.info, category: .network, "📥 Status Code: \(http.statusCode)")
        }

        if let json = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let string = String(data: pretty, encoding: .utf8) {
            AppLogger.log(.info, category: .network, "📦 Response JSON:\n\(string)")
        } else if let string = String(data: data, encoding: .utf8) {
            AppLogger.log(.info, category: .network, "📦 Response Raw:\n\(string)")
        }
    }
}
