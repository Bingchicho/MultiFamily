//
//  AuthorizationInterceptorTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import XCTest
import MultiFamily

final class AuthorizationInterceptorTests: XCTestCase {

    // MARK: - Helpers

    private func makeURLRequest() -> URLRequest {
        URLRequest(url: URL(string: "https://example.com")!)
    }

    // MARK: - Tests

    func test_requiresAuth_true_withToken_addsAuthorizationHeader() async throws {
        // given
        let interceptor = AuthorizationInterceptor(
            tokenProvider: {
                "ACCESS_TOKEN"
            }
        )

        let apiRequest = APIRequest(
            host: .api,
            path: "/profile",
            method: .get,
            requiresAuth: true
        )

        var urlRequest = makeURLRequest()

        // when
        try await interceptor.adapt(apiRequest, urlRequest: &urlRequest)

        // then
        XCTAssertEqual(
            urlRequest.value(forHTTPHeaderField: "Authorization"),
            "Bearer ACCESS_TOKEN"
        )
    }

    func test_requiresAuth_false_doesNotAddAuthorizationHeader() async throws {
        // given
        let interceptor = AuthorizationInterceptor(
            tokenProvider: {
                "ACCESS_TOKEN"
            }
        )

        let apiRequest = APIRequest(
            host: .auth,
            path: "/login",
            method: .post,
            requiresAuth: false
        )

        var urlRequest = makeURLRequest()

        // when
        try await interceptor.adapt(apiRequest, urlRequest: &urlRequest)

        // then
        XCTAssertNil(
            urlRequest.value(forHTTPHeaderField: "Authorization")
        )
    }

    func test_requiresAuth_true_withNilToken_doesNotAddAuthorizationHeader() async throws {
        // given
        let interceptor = AuthorizationInterceptor(
            tokenProvider: {
                nil
            }
        )

        let apiRequest = APIRequest(
            host: .api,
            path: "/profile",
            method: .get,
            requiresAuth: true
        )

        var urlRequest = makeURLRequest()

        // when
        try await interceptor.adapt(apiRequest, urlRequest: &urlRequest)

        // then
        XCTAssertNil(
            urlRequest.value(forHTTPHeaderField: "Authorization")
        )
    }
}
