//
//  UserRepositoryImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//


import XCTest
import MultiFamily

final class UserRepositoryImplTests: XCTestCase {

    func test_login_success_saves_tokens_and_returns_userToken() async throws {
        // given
        let apiClient = MockAPIClient()
        let tokenStore = FakeTokenStore()
        let factory = FakeUserRequestFactory()

        apiClient.response = UserResponseDTO(
            tokenType: "Bearer",
            accessToken: "ACCESS",
            refreshToken: "REFRESH",
            expiresIn: 3600,
            attribute: .mock(),
            identityID: "ID",
            email: "a@test.com",
            clientToken: "TEST_DEVICE"
        )

        let sut = UserRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore,
            userRequestFactory: factory as! UserRequestFactory
        )

        // when
        let token = try await sut.login(
            email: "a@test.com",
            password: "1234"
        )

        // then
        XCTAssertTrue(factory.didMakeLoginRequest)
        XCTAssertEqual(apiClient.calledEndpoint, .login)
        XCTAssertEqual(tokenStore.accessToken, "ACCESS")
        XCTAssertEqual(tokenStore.refreshToken, "REFRESH")
        XCTAssertEqual(token.accessToken, "ACCESS")
    }
    
    func test_refresh_updates_tokens() async throws {
        // given
        let apiClient = MockAPIClient()
        let tokenStore = FakeTokenStore()
        let factory = FakeUserRequestFactory()

        tokenStore.refreshToken = "OLD_REFRESH"

        apiClient.response = UserResponseDTO(
            tokenType: "Bearer",
            accessToken: "NEW_ACCESS",
            refreshToken: "NEW_REFRESH",
            expiresIn: 3600,
            attribute: .mock(),
            identityID: "ID",
            email: "a@test.com",
            clientToken: "TEST_DEVICE"
        )

        let sut = UserRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore,
            userRequestFactory: factory as! UserRequestFactory
        )

        // when
        let token = try await sut.refreshIfNeeded()

        // then
        XCTAssertTrue(factory.didMakeTokenRequest)
        XCTAssertEqual(tokenStore.accessToken, "NEW_ACCESS")
        XCTAssertEqual(tokenStore.refreshToken, "NEW_REFRESH")
        XCTAssertEqual(token.accessToken, "NEW_ACCESS")
    }
}

extension AttributeDTO {
    static func mock() -> AttributeDTO {
        AttributeDTO(
            preferredUsername: "test",
            preferredLanguage: "enUS",
            phone: "000",
            country: "",
            debugLog: false,
            permission: []
        )
    }
}


final class MockAPIClient: APIClient {

    enum CalledEndpoint {
        case login
        case refresh
    }

    var calledEndpoint: CalledEndpoint?
    var response: UserResponseDTO!

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {
        if request.path.contains("login") {
            calledEndpoint = .login
        } else {
            calledEndpoint = .refresh
        }

        return response as! T
    }
}

final class FakeTokenStore: TokenStore {
    var accessToken: String?
    var refreshToken: String?
    func clear() {}
}

final class FakeUserRequestFactory {

    var didMakeLoginRequest = false
    var didMakeTokenRequest = false

    func makeLoginRequest(email: String, password: String) -> UserRequestDTO {
        didMakeLoginRequest = true
        return UserRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE",
            payload: .login(
                LoginPayloadDTO(email: email, password: password)
            )
        )
    }

    func makeTokenRequest() -> UserRequestDTO {
        didMakeTokenRequest = true
        return UserRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE",
            payload: .refreshToken(
                RefreshTokenPayloadDTO(refreshToken: "REFRESH")
            )
        )
    }
}
