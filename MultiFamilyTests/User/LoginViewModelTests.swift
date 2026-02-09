//
//  LoginViewModelTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

import XCTest
import MultiFamily
@MainActor
final class LoginViewModelTests: XCTestCase {

    private var useCase: FakeLoginUseCase!
    private var sut: LoginViewModel!

    override func setUp() {
        super.setUp()
        useCase = FakeLoginUseCase()
        sut = LoginViewModel(useCase: useCase)
    }

    override func tearDown() {
        useCase = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Validation

    func test_loginButton_disabled_whenEmailInvalid() {
        sut.email = "invalid"
        sut.password = "123456"

        XCTAssertFalse(sut.isLoginEnabled)
    }

    func test_loginButton_enabled_whenEmailAndPasswordValid() {
        sut.email = "a@test.com"
        sut.password = "123456"

        XCTAssertTrue(sut.isLoginEnabled)
    }

    // MARK: - Login Action

    func test_login_callsUseCase() async {
        let exp = expectation(description: "login called")

        useCase.onLoginCalled = {
            exp.fulfill()
        }

        sut.email = "a@test.com"
        sut.password = "123456"

        await MainActor.run {
            sut.login()
        }

        await fulfillment(of: [exp], timeout: 1)
    }

    // MARK: - Success Route

    func test_loginSuccess_routesToHome() async {
        let exp = expectation(description: "route to home")

        sut.onRoute = { route in
            if case .home = route {
                exp.fulfill()
            }
        }

        useCase.action = .success
        sut.email = "a@test.com"
        sut.password = "123456"

        await MainActor.run {
            sut.login()
        }

        await fulfillment(of: [exp], timeout: 1)
    }

    // MARK: - Verification Route

    func test_loginVerification_routesToVerification() async {
        let exp = expectation(description: "route to verification")

        sut.onRoute = { route in
            if case .verification(let ticket) = route {
                XCTAssertEqual(ticket, "ticket-123")
                exp.fulfill()
            }
        }

        useCase.action = .verification(ticket: "ticket-123")
        sut.email = "a@test.com"
        sut.password = "123456"

        await MainActor.run {
            sut.login()
        }

        await fulfillment(of: [exp], timeout: 1)
    }

    // MARK: - Failure State

    func test_loginFailure_setsErrorState() async {
        let exp = expectation(description: "error state set")

        sut.onStateChange = { state in
            if case .error = state {
                exp.fulfill()
            }
        }

        useCase.action = .failure(.invalidCredentials)
        sut.email = "a@test.com"
        sut.password = "123456"

        await MainActor.run {
            sut.login()
        }

        await fulfillment(of: [exp], timeout: 1)
    }

   
}

final class FakeLoginUseCase: LoginUseCase {

    enum Action {
        case success
        case verification(ticket: String)
        case failure(LoginError)
    }

    var action: Action = .success
    private(set) var didCallLogin = false
    
    var onLoginCalled: (() -> Void)?


    func login(email: String, password: String) async -> LoginResult {
        didCallLogin = true
        onLoginCalled?()
        switch action {
        case .success:
            return .success
        case .verification(let ticket):
            return .verificationRequired(ticket: ticket)
        case .failure(let error):
            return .failure(error)


        }
    }

    func refreshToken() async -> LoginResult {
        .success
    }
}
