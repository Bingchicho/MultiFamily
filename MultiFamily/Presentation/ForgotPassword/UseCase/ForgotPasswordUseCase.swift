//
//  ForgotPasswordUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

protocol ForgotPasswordUseCase {
    func sendCode(email: String) async -> ForgotPasswordResult
    func resetPassword(email: String, code: String, newPassword: String) async -> ForgotPasswordResult
}

final class ForgotPasswordUseCaseImpl: ForgotPasswordUseCase {
    
    private let repository: ForgotPasswordRepository
    
    init(repository: ForgotPasswordRepository) {
        self.repository = repository
    }
    
    func sendCode(email: String) async -> ForgotPasswordResult {
        do {
            try await repository.sendCode(email: email)
            return .success
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }
    
    func resetPassword(email: String, code: String, newPassword: String) async -> ForgotPasswordResult {
        do {
            try await repository.resetPassword(
                email: email,
                code: code,
                newPassword: newPassword
            )
            return .success
        } catch (let error) {
            switch error {
            case APIClientError.httpStatus(let code, _):
                if code == 401 {
                    return .failure(L10n.Forgotpassword.Code.error)
                }
                return .failure(L10n.Common.Error.network)
            default:
                return .failure(L10n.Common.Error.network)
            }
            
        }
    }
    
    
}
