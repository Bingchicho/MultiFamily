//
//  RegisterVerifyRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

protocol RegisterVerifyRepository {
    func verify(ticket: String, code: String) async throws -> RegisterVerifyResult 
}


