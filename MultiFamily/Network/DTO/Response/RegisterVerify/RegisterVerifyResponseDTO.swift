//
//  RegisterVerifyResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

struct RegisterVerifyResponseDTO: Decodable {

    let ticket: String
    let clientToken: String
}


extension RegisterVerifyResponseDTO {
    func toDomain() -> RegisterVerifyResult {
        if ticket.isEmpty == false {
            return .success
        } else {
            return .failure(L10n.registerError)
        }
    }
}
