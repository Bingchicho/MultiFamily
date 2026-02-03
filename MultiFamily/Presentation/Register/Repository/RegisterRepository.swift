//
//  RegisterRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

protocol RegisterRepository {
    func create(email: String, password: String, name: String, phone: String?, country: String?) async throws -> RegisterResult
 

}
