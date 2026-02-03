//
//  RegisterUseCaseImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

//
//  RegisterUseCaseImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import XCTest
import MultiFamily

final class RegisterUseCaseImplTests: XCTestCase {

    private var repository: MockRegisterRepository!
    private var sut: RegisterUseCaseImpl!

    override func setUp() {
        super.setUp()
        repository = MockRegisterRepository()
        sut = RegisterUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        repository = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_register_success_returnsVerificationRequired() async {
        // given
        repository.action = .success(.success(ticket: "TICKET"))

        // when
        let result = await sut.register(
            email: "a@test.com",
            password: "123456",
            name: "Test",
            phone: nil,
            country: nil
        )

        // then
        switch result {
        case .success(let ticket):
            XCTAssertEqual(ticket, "TICKET")
        default:
            XCTFail("Expected verificationRequired")
        }
    }

    // MARK: - Repository Error → Generic Failure

    func test_register_repositoryError_returnsGenericFailure() async {
        // given
        repository.action = .throwError(DummyError())

        // when
        let result = await sut.register(
            email: "a@test.com",
            password: "123456",
            name: "Test",
            phone: nil,
            country: nil
        )

        // then
        switch result {
        case .failure(let message):
            XCTAssertEqual(message, "註冊失敗，請稍後再試")
        default:
            XCTFail("Expected generic failure")
        }
    }
}
final class MockRegisterRepository: RegisterRepository {

    enum Action {
        case success(RegisterResult)
        case throwError(Error)
    }

    var action: Action = .success(.success(ticket: "TEST"))

    func create(
        email: String,
        password: String,
        name: String,
        phone: String?,
        country: String?
    ) async throws -> RegisterResult {

        switch action {
        case .success(let result):
            return result

        case .throwError(let error):
            throw error
        }
    }
}

private struct DummyError: Error {}
