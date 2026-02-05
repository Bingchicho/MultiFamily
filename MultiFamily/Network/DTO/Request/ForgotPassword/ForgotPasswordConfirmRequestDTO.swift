//
//  ForgotPasswordConfirmRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//



struct ForgotPasswordConfirmRequestDTO: Encodable {

    let applicationID: String
    let clientToken: String
    let ticket: String
    let code: String
    let login: LoginPayloadDTO
 
}
