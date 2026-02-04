//
//  RegisterVerifyUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

protocol RegisterVerifyUseCase {
    func verify(ticket: String,code: String) async -> RegisterVerifyResult
    func resend(email: String) async -> VerifyResendResult
}


final class RegisterVerifyUseCaseImpl: RegisterVerifyUseCase {

    

    private let repository: RegisterVerifyRepository

    init(repository: RegisterVerifyRepository) {
        self.repository = repository
    }

    func verify(ticket: String, code: String) async -> RegisterVerifyResult {

        do {
            return try await repository.verify(
                ticket: ticket,
                code: code
            )

        } catch {
            return .failure(L10n.Verify.error)
        }
    }
    
    func resend(email: String) async -> VerifyResendResult {
        do {
            return try await repository.resend(email: email)

        } catch {
            return .failure(L10n.Verify.error)
        }
    }
    
}
