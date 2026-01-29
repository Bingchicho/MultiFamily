//
//  UserTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import XCTest
import MultiFamily

final class UserTests: XCTestCase {
    struct FakeDeviceIdentifierProvider: DeviceIdentifierProvider {
        let clientToken: String
    }
    
    struct FakeEnvironmentConfig: EnvironmentConfig {
        let applicationID: String
    }
    
    struct FakeTokenStore: TokenStore {
        var accessToken: String?
        var refreshToken: String?
        func clear() {}
    }
    
    
    func test_login_uses_device_token() {
        let factory = UserRequestFactory(
            env: FakeEnvironmentConfig(applicationID: "TestApp"),
            device: FakeDeviceIdentifierProvider(clientToken: "FAKE-DEVICE-ID"),
            tokenStore: FakeTokenStore()
        )

        let dto = factory.makeLoginRequest(
            email: "a@test.com",
            password: "1234"
        )

        XCTAssertEqual(dto.clientToken, "FAKE-DEVICE-ID")
    }
}


