//
//  VerifyResendResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

// MARK: - VerifyResendResponseDTO

struct VerifyResendResponseDTO: Decodable {

    let verifyRequired: Bool
    let verifyRequiredAction: VerifyRequiredAction
    let ticket: String
    let clientToken: String
}


extension VerifyResendResponseDTO {

    func toDomain() -> VerifyResendResult {
        if ticket.isEmpty == false {
            return .success(ticket)
        } else {
            return .failure(L10n.Verify.Resend.error)
        }
    }
}



