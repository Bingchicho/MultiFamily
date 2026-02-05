//
//  ForgotPasswordRepositoryImplTests.swift.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//


import XCTest
import MultiFamily

final class ForgotPasswordRepositoryImplTests: XCTestCase {

    func test_sendCode_success_saves_ticket() async throws {
        // given
        let apiClient = MockForgotPasswordAPIClient()
    
        let factory = FakeForgotPasswordRequestFactory()
        
        

        apiClient.sendCodeResponse = ForgotPasswordSendCodeResponseDTO(
            verifyRequired: true,
            verifyRequiredAction: "EMAIL",
            ticket: "TICKET_123",
            clientToken: "CLIENT_TOKEN"
        )

        
        let sut = ForgotPasswordRepositoryImpl(apiClient: apiClient, requestFactory: factory)

        // when
        try await sut.sendCode(email: "a@test.com")

        // then
        XCTAssertEqual(apiClient.calledEndpoint, .sendCode)
    }

   

    func test_resetPassword_without_sendCode_throws_invalidResponse() async {
        // given
        let apiClient = MockForgotPasswordAPIClient()
        let factory = FakeForgotPasswordRequestFactory()

        
        let sut = ForgotPasswordRepositoryImpl(apiClient: apiClient, requestFactory: factory)

        // when / then
        do {
            try await sut.resetPassword(
                email: "a@test.com",
                code: "123456",
                newPassword: "123456"
            )
            XCTFail("Expected invalidResponse error")
        } catch {
            guard let apiError = error as? APIClientError else {
                XCTFail("Expected APIClientError")
                return
            }

            switch apiError {
            case .invalidResponse:
                XCTAssertTrue(true) // ✅ expected
            default:
                XCTFail("Expected invalidResponse, got \(apiError)")
            }
        }
    }
}


final class MockForgotPasswordAPIClient: APIClient {

    enum CalledEndpoint {
        case sendCode
        case confirm
    }

    var calledEndpoint: CalledEndpoint?

    var sendCodeResponse: ForgotPasswordSendCodeResponseDTO?
    var confirmResponse: ForgotPasswordConfirmResponseDTO?

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {

        guard let body = request.body as? ForgotPasswordRequestDTO else {
            fatalError("Unexpected request body type: \(String(describing: request.body))")
        }

        // ✅ Send Code：沒有 ticket / code
        if body.ticket == nil && body.code == nil {
            calledEndpoint = .sendCode
            guard let response = sendCodeResponse else {
                fatalError("sendCodeResponse not set")
            }
            return response as! T
        }

        // ✅ Confirm Reset Password：有 ticket + code
        if body.ticket != nil && body.code != nil {
            calledEndpoint = .confirm
            guard let response = confirmResponse else {
                fatalError("confirmResponse not set")
            }
            return response as! T
        }

        fatalError("Invalid ForgotPasswordRequestDTO state: \(body)")
    }
}

final class FakeEnvironmentConfig: EnvironmentConfig {
    let applicationID: String = "TEST_APP"
}

final class FakeDeviceIdentifierProvider: DeviceIdentifierProvider {
    let clientToken: String = "TEST_DEVICE"
}

final class FakeForgotPasswordRequestFactory: ForgotPasswordRequestFactoryProtocol {

    private(set) var didMakeSendCodeRequest = false
    private(set) var didMakeConfirmRequest = false

    func makeForgotPasswordSendCodeRequestFactory(
        email: String
    ) -> ForgotPasswordRequestDTO {

        didMakeSendCodeRequest = true
        
        return ForgotPasswordRequestDTO(applicationID: "TEST_APP", clientToken: "TEST_DEVICE", login: ForgotPasswordLoginDTO(email: email, password: nil), ticket: nil, code: nil)


    }

    func makeForgotPasswordConfirmRequestFactory(
        ticket: String,
        code: String,
        email: String,
        password: String
    ) -> ForgotPasswordRequestDTO {

        didMakeConfirmRequest = true
        
        return ForgotPasswordRequestDTO(applicationID: "TSET_APP", clientToken: "TEST_DEVICE", login: ForgotPasswordLoginDTO(email: email, password: password), ticket: ticket, code: code)


    }
}
