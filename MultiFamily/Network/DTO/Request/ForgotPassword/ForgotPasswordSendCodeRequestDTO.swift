//
//  ForgotPasswordSendCodeRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

struct ForgotPasswordSendCodeRequestDTO: Encodable {
    let applicationID: String
    let login: LoginEmailDTO
    let clientToken: String
}

struct LoginEmailDTO: Encodable {
    let email: String
}
