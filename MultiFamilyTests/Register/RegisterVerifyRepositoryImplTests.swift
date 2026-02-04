//
//  RegisterVerifyRepositoryImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

//
//  RegisterVerifyRepositoryImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

import XCTest
import MultiFamily

final class RegisterVerifyRepositoryImplTests: XCTestCase {

    // MARK: - Verify

    func test_verify_success_returns_domain_result() async throws {
        // given
        let apiClient = MockRegisterVerifyAPIClient()
        let verifyFactory = FakeRegisterVerifyRequestFactory()
        let resendFactory = FakeVerifyResendRequestFactory()

        apiClient.verifyResponse = RegisterVerifyResponseDTO(
            ticket: "TICKET_123",
            clientToken: "CLIENT_TOKEN"
        )

        let sut = RegisterVerifyRepositoryImpl(
            apiClient: apiClient,
            registerVerifyFactory: verifyFactory,
            verifyResendFactory: resendFactory
        )

        // when
        let result = try await sut.verify(
            ticket: "TICKET_123",
            code: "123456"
        )

        // then
        XCTAssertTrue(verifyFactory.didMakeVerifyRequest)
        XCTAssertEqual(apiClient.calledEndpoint, .verify)
     
    }

    // MARK: - Resend

    func test_resend_success_returns_domain_result() async throws {
        // given
        let apiClient = MockRegisterVerifyAPIClient()
        let verifyFactory = FakeRegisterVerifyRequestFactory()
        let resendFactory = FakeVerifyResendRequestFactory()

        apiClient.resendResponse = VerifyResendResponseDTO(
            verifyRequired: true,
            verifyRequiredAction: .email,
            ticket: "TICKET_RESEND",
            clientToken: "CLIENT_TOKEN"
        )

        let sut = RegisterVerifyRepositoryImpl(
            apiClient: apiClient,
            registerVerifyFactory: verifyFactory,
            verifyResendFactory: resendFactory
        )

        // when
        let result = try await sut.resend(email: "a@test.com")

        // then
        XCTAssertTrue(resendFactory.didMakeResendRequest)
        XCTAssertEqual(apiClient.calledEndpoint, .resend)

    }
}

final class MockRegisterVerifyAPIClient: APIClient {

    enum CalledEndpoint {
        case verify
        case resend
    }

    var calledEndpoint: CalledEndpoint?

    var verifyResponse: RegisterVerifyResponseDTO?
    var resendResponse: VerifyResendResponseDTO?

    func request<T>(_ request: APIRequest) async throws -> T where T: Decodable {
        
        if request.path.contains("resend") {
            calledEndpoint = .resend
            guard let response = resendResponse else {
                fatalError("resendResponse not set")
            }
            return response as! T
        }

        
        if request.path.contains("verify") {
            calledEndpoint = .verify
            guard let response = verifyResponse else {
                fatalError("verifyResponse not set")
            }
            return response as! T
        }


        fatalError("Unexpected endpoint")
    }
}

final class FakeRegisterVerifyRequestFactory: RegsiterVerifyRequestFactoryProtocol {

    private(set) var didMakeVerifyRequest = false

    func makeRegisterVerifyRequest(
        ticket: String,
        code: String
    ) -> RegisterVerifyRequestDTO {

        didMakeVerifyRequest = true

        return RegisterVerifyRequestDTO(
            ticket: ticket,
            code: code,
            clientToken: "TEST_DEVICE"
        )
    }
}

final class FakeVerifyResendRequestFactory: VerifyResendRequestFactoryProtocol {

    private(set) var didMakeResendRequest = false

    func makeVerifyResendRequest(email: String) -> VerifyResendRequestDTO {

        didMakeResendRequest = true

        return VerifyResendRequestDTO(
            applicationID: "TEST_APP",
            login: VerifyResendLoginDTO(email: email),
            verifyRequiredAction: .email,
            clientToken: "TEST_DEVICE"
        )
    }
}
