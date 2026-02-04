//
//  VerifyResendRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

// MARK: - VerifyResendRequestDTO

struct VerifyResendRequestDTO: Encodable {

    let applicationID: String
    let login: VerifyResendLoginDTO
    let verifyRequiredAction: VerifyRequiredAction
    let clientToken: String
}

// MARK: - Nested DTO

struct VerifyResendLoginDTO: Encodable {
    let email: String
}

enum VerifyRequiredAction: String, Codable {
    case email = "EMAIL"
    case sms = "SMS"       // 預留
}
