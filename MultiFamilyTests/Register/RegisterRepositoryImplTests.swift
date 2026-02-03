//
//  RegisterRepositoryImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//


import XCTest
import MultiFamily

final class RegisterRepositoryImplTests: XCTestCase {

    func test_create_success_returns_verification_required() async throws {
        // given
        let apiClient = MockRegisterAPIClient()
        let factory = FakeRegisterRequestFactory()

        apiClient.response = RegisterResponseDTO(
            verifyRequired: true,
            verifyRequiredAction: .email,
            ticket: "TICKET_123",
            clientToken: "CLIENT_TOKEN"
        )

        let sut = RegisterRepositoryImpl(
            apiClient: apiClient,
            requestFactory: factory
        )

        // when
        let result = try await sut.create(
            email: "a@test.com",
            password: "123456",
            name: "Test User",
            phone: "0912345678",
            country: "TW"
        )

        // then
        XCTAssertTrue(factory.didMakeRegisterRequest)
        XCTAssertEqual(apiClient.calledEndpoint, .create)

        switch result {
        case .success(let ticket):
            XCTAssertEqual(ticket, "TICKET_123")
        default:
            XCTFail("Expected verificationRequired")
        }
    }
}

final class MockRegisterAPIClient: APIClient {

    enum CalledEndpoint {

        case create
    }

    var calledEndpoint: CalledEndpoint?
    var response: RegisterResponseDTO!

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {
        if request.path.contains("create") {
            calledEndpoint = .create
        }

        return response as! T
    }
}

final class FakeRegisterRequestFactory: RegsiterRequestFactoryProtocol {

    private(set) var didMakeRegisterRequest = false

    func makeRegisterRequest(
        email: String,
        password: String,
        name: String,
        phone: String?,
        country: String?
    ) -> RegisterRequestDTO {

        didMakeRegisterRequest = true

        return RegisterRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE",
            attribute: AttributeDTO(
                preferredUsername: name,
                preferredLanguage: "enUS",
                phone: phone,
                country: country,
                debugLog: nil,
                permission: nil
            ),
            login: LoginPayloadDTO(
                email: email,
                password: password
            ),
            inviteCode: nil
        )
    }
}
