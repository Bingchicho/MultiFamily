//
//  ForgotPasswordSendCodeResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

struct ForgotPasswordSendCodeResponseDTO: Decodable {
    let verifyRequired: Bool
    let verifyRequiredAction: String
    let ticket: String
    let clientToken: String
}


