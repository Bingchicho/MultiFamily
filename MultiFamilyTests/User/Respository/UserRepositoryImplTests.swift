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
        let attribute = FakeUserAttributeStore()

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
            userRequestFactory: factory,
            userAttribute: attribute
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
        XCTAssertEqual(attribute.currentUser?.username, "test")
    }
    
    func test_refresh_updates_tokens() async throws {
        // given
        let apiClient = MockAPIClient()
        let tokenStore = FakeTokenStore()
        let factory = FakeUserRequestFactory()
        let attribute = FakeUserAttributeStore()

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
            userRequestFactory: factory,
            userAttribute: attribute
        )

        // when
        let token = try await sut.refreshIfNeeded()

        // then
        XCTAssertTrue(factory.didMakeTokenRequest)
        XCTAssertEqual(tokenStore.accessToken, "NEW_ACCESS")
        XCTAssertEqual(tokenStore.refreshToken, "NEW_REFRESH")
        XCTAssertEqual(attribute.currentUser?.username, "test")
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

final class FakeUserRequestFactory: UserRequestFactoryProtocol {

    private(set) var didMakeLoginRequest = false
    private(set) var didMakeTokenRequest = false

    func makeLoginRequest(
        email: String,
        password: String
    ) -> UserRequestDTO {

        didMakeLoginRequest = true

        return UserRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE",
            payload: .login(
                LoginPayloadDTO(
                    email: email,
                    password: password
                )
            )
        )
    }

    func makeTokenRequest() -> UserRequestDTO {

        didMakeTokenRequest = true

        return UserRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE",
            payload: .refreshToken(
                RefreshTokenPayloadDTO(
                    refreshToken: "TEST_REFRESH"
                )
            )
        )
    }
}

final class FakeUserAttributeStore: UserAttributeStore {

    private(set) var currentUser: UserAttribute?
    private(set) var didSaveUser = false
    private(set) var didClear = false

    func save(_ user: UserAttribute) {
        didSaveUser = true
        currentUser = user
    }

    func clear() {
        didClear = true
        currentUser = nil
    }
}
