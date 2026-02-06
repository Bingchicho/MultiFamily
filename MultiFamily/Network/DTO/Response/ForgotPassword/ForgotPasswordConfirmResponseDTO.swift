//
//  ForgotPasswordConfirmResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

struct ForgotPasswordConfirmResponseDTO: Decodable {
    let verifyRequired: Bool

    let clientToken: String
}

extension ForgotPasswordConfirmResponseDTO {
    func toDomain() -> ForgotPasswordResult {
        if !verifyRequired {
            return .success
        } else {
            return .failure(L10n.Common.Error.network)
        }
    }

}
