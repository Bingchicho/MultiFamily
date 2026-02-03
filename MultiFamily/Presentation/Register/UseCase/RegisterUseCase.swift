//
//  RegisterUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

protocol RegisterUseCase {
    func register(
        email: String,
        password: String,
        name: String,
        phone: String?,
        country: String?
    ) async -> RegisterResult
}

final class RegisterUseCaseImpl: RegisterUseCase {
    
    private let repository: RegisterRepository
    
    init(repository: RegisterRepository) {
        self.repository = repository
    }
    
    func register(
        email: String,
        password: String,
        name: String,
        phone: String?,
        country: String?
    ) async -> RegisterResult {
        
        do {
            return try await repository.create(
                email: email,
                password: password,
                name: name,
                phone: phone,
                country: country
            )
        } catch {
            return .failure(L10n.registerError)
        }
    }
}
