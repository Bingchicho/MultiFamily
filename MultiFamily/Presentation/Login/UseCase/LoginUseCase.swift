//
//  UserUseCae.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//


protocol LoginUseCase {
    func login(email: String, password: String) async -> LoginResult
    func refreshToken() async -> LoginResult
}


