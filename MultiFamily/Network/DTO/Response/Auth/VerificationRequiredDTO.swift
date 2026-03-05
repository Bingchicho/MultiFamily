//
//  VerificationRequiredDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct VerificationRequiredDTO: Decodable {
    let verifyRequired: Bool
    let verifyRequiredAction: String
    let ticket: String
    let clientToken: String
}
