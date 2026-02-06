//
//  ForgotPasswordRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

protocol ForgotPasswordRepository {
    func sendCode(email: String) async throws
    func resetPassword(email: String, code: String, newPassword: String) async throws  -> ForgotPasswordResult
}
