//
//  LoginUseCaseImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import XCTest
import MultiFamily

final class LoginUseCaseImplTests: XCTestCase {

    private var repository: MockUserRepository!
    private var sut: LoginUseCaseImpl!

    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        sut = LoginUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        repository = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_login_success_returnsSuccess() async {
        // given
        repository.loginAction = .success

        // when
        let result = await sut.login(email: "a@test.com", password: "123456")

        // then
        XCTAssertEqual(result, .success)
    }

    // MARK: - 401 Invalid Credentials

    func test_login_401_returnsInvalidCredentialsFailure() async {
        // given
        let error = APIClientError.httpStatus(code: 401, data: Data())
        repository.loginAction = .throwError(error)

        // when
        let result = await sut.login(email: "a@test.com", password: "wrong")

        // then
        switch result {
        case .failure(let loginError):
            XCTAssertEqual(loginError, .invalidCredentials)
        default:
            XCTFail("Expected invalidCredentials failure")
        }
    }

    // MARK: - 423 Verification Required

    func test_login_423_returnsVerificationRequired() async {
        // given
        let json = """
        {
          "verifyRequired": true,
          "verifyRequiredAction": "EMAIL",
          "ticket": "test-ticket"
        }
        """.data(using: .utf8)!

        let error = APIClientError.httpStatus(code: 423, data: json)
        repository.loginAction = .throwError(error)

        // when
        let result = await sut.login(email: "a@test.com", password: "123456")

        // then
        switch result {
        case .verificationRequired(let ticket):
            XCTAssertEqual(ticket, "test-ticket")
        default:
            XCTFail("Expected verificationRequired result")
        }
    }

    // MARK: - Timeout

    func test_login_timeout_returnsNetworkFailure() async {
        // given
        let error = APIClientError.timeout
        repository.loginAction = .throwError(error)

        // when
        let result = await sut.login(email: "a@test.com", password: "123456")

        // then
        switch result {
        case .failure(let loginError):
            XCTAssertEqual(loginError, .network)
        default:
            XCTFail("Expected network failure")
        }
    }

    // MARK: - Refresh Token (same mapping)

    func test_refreshToken_timeout_returnsNetworkFailure() async {
        // given
        let error = APIClientError.timeout
        repository.refreshAction = .throwError(error)

        // when
        let result = await sut.refreshToken()

        // then
        switch result {
        case .failure(let loginError):
            XCTAssertEqual(loginError, .network)
        default:
            XCTFail("Expected network failure")
        }
    }
}

final class MockUserRepository: UserRepository {

    enum Action {
        case success
        case throwError(Error)
    }

    var loginAction: Action = .success
    var refreshAction: Action = .success

    func login(email: String, password: String) async throws {
        switch loginAction {
        case .success:
            return
        case .throwError(let error):
            throw error
        }
    }

    func refreshIfNeeded() async throws {
        switch refreshAction {
        case .success:
            return
        case .throwError(let error):
            throw error
        }
    }
}
