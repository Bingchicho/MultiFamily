//
//  RegisterResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import Foundation

struct RegisterResponseDTO: Decodable {

    let verifyRequired: Bool
    let verifyRequiredAction: VerifyActionDTO
    let ticket: String
    let clientToken: String
}

enum VerifyActionDTO: String, Decodable {
    case email = "EMAIL"
}


extension RegisterResponseDTO {
    func toDomain() -> RegisterResult {
        if verifyRequired {
            return .success(ticket: ticket)
        } else {
            return .failure(L10n.Register.error)
        }
    }
}
