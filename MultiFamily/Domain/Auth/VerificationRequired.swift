//
//  VerificationRequired.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct VerificationRequired {
    let action: VerificationAction
    let ticket: String
    let clientToken: String
}

enum VerificationAction: String {
    case email = "EMAIL"
    case sms = "SMS"
}
