//
//  LoginUseCaseImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

final class LoginUseCaseImpl: LoginUseCase {

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository

    }
    
    private func mapErrorToLoginResult(_ error: Error) -> LoginResult {
        guard let apiError = error as? APIClientError else {
            return .failure(.unknown)
        }

        switch apiError {

        case .httpStatus(let code, let data):
            if code == 423 {
                let dto = try? JSONDecoder().decode(
                    VerificationRequiredDTO.self,
                    from: data
                )
                return .verificationRequired(ticket: dto?.ticket ?? "")
            }

            if code == 401 {
                return .failure(.invalidCredentials)
            }

            return .failure(.unknown)

        case .timeout:
            return .failure(.network)

        default:
            return .failure(.unknown)
        }
    }

    func login(email: String, password: String) async -> LoginResult {
        do {
            try await repository.login(email: email, password: password)
            return .success
        } catch {
            return mapErrorToLoginResult(error)
        }
    }
    
    func refreshToken() async -> LoginResult {
        do {
            try await repository.refreshIfNeeded()
            return .success
        } catch {
            return mapErrorToLoginResult(error)
        }
    }
}
