//
//  RegisterVerifyUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

protocol RegisterVerifyUseCase {
    func verify(ticket: String,code: String) async -> RegisterVerifyResult
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
            return .failure("驗證失敗，請稍後再試")
        }
    }
}
