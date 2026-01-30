//
//  UserRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

protocol UserRepository {
    func login(email: String, password: String) async throws
    func refreshIfNeeded() async throws 
}
