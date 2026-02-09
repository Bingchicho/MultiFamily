//
//  ProfileUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//


protocol ProfileUseCase {
    func changeName(email: String, name: String) async -> UpdateProfileResult
    func changeMobile(email: String, mobile: String) async -> UpdateProfileResult
    func changePassword(email: String, oldPassword: String, password: String) async -> UpdateProfileResult
}

final class ProfileUseCaseImpl: ProfileUseCase {

    
    
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func changeName(email: String, name: String) async -> UpdateProfileResult {
        
        do {
             try await repository.updateName(name: name, email: email)
            return .success
        } catch {
            return .failure(L10n.Register.error)
        }
    }
    
    func changeMobile(email: String, mobile: String) async -> UpdateProfileResult {
        do {
            try await repository.updateMobile(mobile: mobile, email: email)
            return .success
        } catch {
            return .failure(L10n.Register.error)
        }
    }
    
    func changePassword(email: String, oldPassword: String, password: String) async -> UpdateProfileResult {
        do {
             try await repository.updatePassword(email: email, oldPassword: oldPassword, password: password)
            return .success
        } catch {
            return .failure(L10n.Register.error)
        }
    }
    
   
}
